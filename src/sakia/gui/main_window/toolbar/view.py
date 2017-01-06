from PyQt5.QtWidgets import QFrame, QAction, QMenu, QSizePolicy, QInputDialog, QDialog
from sakia.gui.widgets.dialogs import dialog_async_exec
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import QObject, QT_TRANSLATE_NOOP, Qt
from .toolbar_uic import Ui_SakiaToolbar


class ToolbarView(QFrame, Ui_SakiaToolbar):
    """
    The model of Navigation component
    """
    _action_publish_uid_text = QT_TRANSLATE_NOOP("ToolbarView", "Publish UID")
    _action_revoke_uid_text = QT_TRANSLATE_NOOP("ToolbarView", "Revoke UID")

    def __init__(self, parent):
        super().__init__(parent)
        self.setupUi(self)

        tool_menu = QMenu(self.tr("Tools"), self.toolbutton_menu)
        self.toolbutton_menu.setMenu(tool_menu)

        self.action_revoke_uid = QAction(self.tr(ToolbarView._action_revoke_uid_text), self)
        tool_menu.addAction(self.action_revoke_uid)

        self.action_add_connection = QAction(self.tr("Add a connection"), tool_menu)
        tool_menu.addAction(self.action_add_connection)

        self.action_parameters = QAction(self.tr("Settings"), tool_menu)
        tool_menu.addAction(self.action_parameters)

        self.setSizePolicy(QSizePolicy.Maximum, QSizePolicy.Minimum)
        self.setMaximumHeight(60)

    async def ask_for_connection(self, connections):
        connections_titles = [c.title() for c in connections]
        input_dialog = QInputDialog()
        input_dialog.setComboBoxItems(connections_titles)
        input_dialog.setWindowTitle(self.tr("Membership"))
        input_dialog.setLabelText(self.tr("Select a connection"))
        await dialog_async_exec(input_dialog)
        result = input_dialog.textValue()

        if input_dialog.result() == QDialog.Accepted:
            for c in connections:
                if c.title() == result:
                    return c
