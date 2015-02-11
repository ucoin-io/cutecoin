'''
Created on 31 janv. 2015

@author: inso
'''
import logging
from ucoinpy.api import bma
from ucoinpy.documents.transaction import Transaction


class Transfer(object):
    '''
    A transaction
    '''
    TO_SEND = 0
    AWAITING = 1
    VALIDATED = 2
    REFUSED = 3
    SENT = 4
    DROPPED = 5

    def __init__(self, txdoc, state, metadata):
        '''
        Constructor
        '''
        self.txdoc = txdoc
        self.state = state
        self.metadata = metadata

    @classmethod
    def initiate(cls, block, time, amount, issuer, receiver, comment):
        return cls(None, Transfer.TO_SEND, {'block': block,
                                             'time': time,
                                             'amount': amount,
                                             'issuer': issuer,
                                             'receiver': receiver,
                                             'comment': comment})

    @classmethod
    def create_validated(cls, txdoc, metadata):
        return cls(txdoc, Transfer.VALIDATED, metadata)

    @classmethod
    def load(cls, data):
        if data['state'] is Transfer.TO_SEND:
            txdoc = None
        else:
            txdoc = Transaction.from_signed_raw(data['txdoc'])
        return cls(txdoc, data['state'], data['metadata'])

    def jsonify(self):
        if self.txdoc:
            txraw = self.txdoc.signed_raw()
        else:
            txraw = None
        return {'txdoc': txraw,
                'state': self.state,
                'metadata': self.metadata}

    def send(self, txdoc, community):
        try:
            self.txdoc = txdoc
            community.broadcast(bma.tx.Process,
                        post_args={'transaction': self.txdoc.signed_raw()})
            self.state = Transfer.AWAITING
        except ValueError as e:
            if '400' in e:
                self.state = Transfer.REFUSED
            raise
        finally:
            self.metadata['block'] = community.current_blockid()['number']
            self.metadata['time'] = community.get_block().mediantime

    def check_registered(self, tx, metadata):

        logging.debug("{0} > {1} ?".format(metadata['block'],
                                           self.metadata['block'] + 15))
        if tx.signed_raw() == self.txdoc.signed_raw():
            self.state = Transfer.VALIDATED
            self.metadata = metadata

    def check_refused(self, block):
        if block > self.metadata['block'] + 15:
            self.state = Transfer.REFUSED

    def drop(self):
        self.state = Transfer.DROPPED


class Received(Transfer):
    def __init__(self, txdoc, metadata):
        '''
        Constructor
        '''
        super().__init__(txdoc, Transfer.VALIDATED, metadata)

    @classmethod
    def load(cls, data):
        txdoc = Transaction.from_signed_raw(data['txdoc'])
        return cls(txdoc, data['metadata'])