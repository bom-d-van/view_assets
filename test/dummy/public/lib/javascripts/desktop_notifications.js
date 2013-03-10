/**
 * @class Wando.notify
 * @description
 *
 * google桌面通知
 *
 * @example
 *    Wando.notify("温馨提示", "您有3条未读信息")
 */


Ext.ns("Wando.notify")

Wando.notify = function(t, e) {
    if (window.webkitNotifications) {
        if (window.webkitNotifications.checkPermission() == 0) {
            var notification_test = window.webkitNotifications.createNotification("images/desktop_notifications/cy.png", t, e);
            //notification_test.display = function() {}
            //notification_test.onerror = function() {}
            //notification_test.onclose = function() {}
            notification_test.onclick = function() {this.cancel();}
            notification_test.show();
          } else {
                window.webkitNotifications.requestPermission(notify);
        }
    } 
};

