#include "httputils.h"


HttpUtils::HttpUtils(QObject *parent)
    : QObject{parent}
{
    manager = new QNetworkAccessManager(this); // 管理
    // 绑定，获取请求后发出finished信号，
    connect(manager, SIGNAL(finished(QNetworkReply*)),this,SLOT(replyFinished(QNetworkReply*)));
}

void HttpUtils::connet(QString url)
{
    // 网络请求
    QNetworkRequest request;
    request.setUrl(QUrl(BASE_URL + url));

    manager->get(request); // 获取网络请求
}

void HttpUtils::replyFinished(QNetworkReply *reply)
{
    emit replySignal(reply->readAll()); // 获取reply的全部内容，并发送
}















