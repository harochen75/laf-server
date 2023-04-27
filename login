import cloud from '@lafjs/cloud'

const { v4: uuidv4 } = require('uuid');

const db = cloud.database()

export async function main(ctx: FunctionContext) {

  const data = ctx.body;

  if (!data.phone || !data.password) {
    return { code: 0, errMsg: '请输入用户名和密码' };
  }

  let res = await db.collection('account').where({ phone: data.phone, password: data.password }).count();

  if (!res.ok || (res.ok && res.total <= 0)) {
    return { code: 0, errMsg: '账号或密码错误！' };
  }

  let strUUID = uuidv4();

  await db.collection('token').add({ phone: data.phone, token: strUUID, create: Date.now(), expire: Date.now() + 2 *60 * 60 * 1000 });

  return {
    code: 1, data: {
      access_token: strUUID
    }
  };
}
