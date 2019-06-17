function openUserBasicInfo(userId) {
    var dlg = openSimpleDialog({
        title: "用户基本信息",
        width: 440,
        height: 600,
        href: 'user/basicinfo.do?userId=' + userId
    });
}