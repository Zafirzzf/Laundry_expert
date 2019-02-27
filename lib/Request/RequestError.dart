
class RequetError {
  String ret;
  RequetError(this.ret);

  String alertMsg() {
    switch (ret) {
      case '301': return '订单还未支付'; break;
      default: return '未定义错误${ret}'; break;
    }
  }
}