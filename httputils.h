#ifndef HTTPUTILS_H
#define HTTPUTILS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class HttpUtils : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtils(QObject *parent = nullptr);

    Q_INVOKABLE void connet(QString url); // 连接一个链接
    Q_INVOKABLE void replyFinished(QNetworkReply *reply); // qml能够调用这个函数

signals:
    void replySignal(QString reply); // 发送内容

private:
    QNetworkAccessManager *manager;
    QString BASE_URL = "http://localhost:3000/"; // 基地址，本地的3000端口

};

#endif // HTTPUTILS_H



















