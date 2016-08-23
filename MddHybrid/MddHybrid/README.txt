

Native-Javascript
###################

在Native 端 定义注册 Javascript 调用的方法名规定（即handlerName）：如下


1、goBack            //webView返回上一级
2、close             //关闭应用
3、exit              //退出应用
4、scanQR            //扫描二维码
    扫描到数据后的返回字段：
    {"scanResult":'result'}

5、picture           //获取照片(拍照，相册)
    选择图片后 将 图片转成 base64字符串，并 将字符串 回传给h5
    字段说明：
    {'picBase64':'imgBase64'}

6、phoneCall         //拨打电话
    拨打电话的电话号码传递格式
    {'mobile':'value'}

7、requestData       //请求数据
    数据请求的参数格式：
    {'url':'http://tios.meididi88.com/office.php/v1/Test/index','parameters':{}}
    字段名
    url:  数据请求的接口url
    parameters:  数据请求的 参数 使用json字符串传递：{'name':'value'}




