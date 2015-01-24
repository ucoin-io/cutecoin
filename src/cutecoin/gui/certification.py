'''
Created on 24 dec. 2014

@author: inso
'''
from PyQt5.QtWidgets import QDialog, QMessageBox
from ..tools.exceptions import NoPeerAvailable
from ..gen_resources.certification_uic import Ui_CertificationDialog


class CertificationDialog(QDialog, Ui_CertificationDialog):

    '''
    classdocs
    '''

    def __init__(self, certifier, password_asker):
        '''
        Constructor
        '''
        super().__init__()
        self.setupUi(self)
        self.certifier = certifier
        self.password_asker = password_asker
        self.community = self.certifier.communities[0]

        for community in self.certifier.communities:
            self.combo_community.addItem(community.currency)

        for contact in certifier.contacts:
            self.combo_contact.addItem(contact.name)

    def accept(self):
        if self.radio_contact.isChecked():
            index = self.combo_contact.currentIndex()
            pubkey = self.certifier.contacts[index].pubkey
        else:
            pubkey = self.edit_pubkey.text()

        password = self.password_asker.ask()
        if password == "":
            return

        try:
            self.certifier.certify(password, self.community, pubkey)
            QMessageBox.information(self, "Certification",
                                 "Success certifying {0} from {1}".format(pubkey,
                                                                          self.community.currency))
        except ValueError as e:
            QMessageBox.critical(self, "Certification",
                                 "Something wrong happened : {0}".format(e),
                                 QMessageBox.Ok)
            return
        except NoPeerAvailable as e:
            QMessageBox.critical(self, "Certification",
                                 "Couldn't connect to network : {0}".format(e),
                                 QMessageBox.Ok)
            return
        except Exception as e:
            QMessageBox.critical(self, "Error",
                                 "{0}".format(e),
                                 QMessageBox.Ok)
            return

        super().accept()

    def change_current_community(self, index):
        self.community = self.certifier.communities[index]

    def recipient_mode_changed(self, pubkey_toggled):
        self.edit_pubkey.setEnabled(pubkey_toggled)
        self.combo_contact.setEnabled(not pubkey_toggled)