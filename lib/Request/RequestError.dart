
class RequetError {
  String ret;
  RequetError(this.ret);

  String alertMsg() {
    switch (ret) {
      case '100': return '手机号不存在'; break;
      case '101': return '密码错误'; break;
      case '102': return '状态无效'; break;
      case '200': return '顾客存储失败'; break;
      case '201': return '余额不足'; break;
      case '202': return '会员无法从已支付变为未支付'; break;
      case '203': return '初次充值时不能为负数'; break;
      case '204': return '该顾客不是会员'; break;
      case '301': return '订单还未支付'; break;
      case '401': return '衣服信息不能为空'; break;

      case '301': return '订单还未支付'; break;
      default: return '未定义错误${ret}'; break;
    }
  }
}