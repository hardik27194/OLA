package com.lohool.ola.pay.alipay;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;







import android.widget.Toast;

import com.alipay.sdk.app.PayTask;
import com.lohool.ola.HTTP;
import com.lohool.ola.LuaContext;
import com.lohool.ola.Main;
import com.lohool.ola.UIFactory;
import com.lohool.ola.util.StringUtil;


public class AliPay
{

	public static AliPay instance;
	
	String callback;
	
	private static final int SDK_PAY_FLAG = 1;
	
	public static AliPay create() 
	{
		try
		{
			return new AliPay();
		} catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * call alipay sdk pay. 调用SDK支付
	 * 
	 */
	public void pay(String title,final String payInfo,String callback) {

		this.callback=callback;
		if(callback!=null)this.callback=callback.trim();
		//include the sign message
//		String orderGenUrl="http://192.168.0.107:8080/ct/pay/alipay.action?cmd=genord";
//		HTTP http=HTTP.create(orderGenUrl);
//		http.sendRequest();
//		http.receive();
//		final String payInfo =http.getContent().trim(); //getOrderInfo("测试的商品", "该测试商品的详细描述", "0.01");
//		System.out.println(payInfo);
//		/**
//		 * 特别注意，这里的签名逻辑需要放在服务端，切勿将私钥泄露在代码中！
//		 */
//		String sign = sign(orderInfo);
//		try {
//			/**
//			 * 仅需对sign 做URL编码
//			 */
//			sign = URLEncoder.encode(sign, "UTF-8");
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
//
//		/**
//		 * 完整的符合支付宝参数规范的订单信息
//		 */
//		final String payInfo = orderInfo + "&sign=\"" + sign + "\"&" + getSignType();

		
		Log.d("Pay Request", payInfo);
		
		PayListener pl=new PayListener(title,payInfo,callback);

		// 必须异步调用
		Thread payThread = new Thread(pl);
		payThread.start();
	}

	class PayListener implements Runnable
	{
		String payInfo;
		String callback;
		String title;
		public PayListener(String title,String payInfo,String callback)
		{
			this.title=title;
			this.payInfo=payInfo;
			this.callback=callback;
		}
		@Override
		public void run() {
			// 构造PayTask 对象
			PayTask alipay = new PayTask(Main.activity);
			// 调用支付接口，获取支付结果
			String result = alipay.pay(payInfo.trim(), true);
			
			//resultStatus={9000};memo={};result={partner="2088421861254786"&seller_id="yuchuang-tech@innodriver.com"&out_trade_no="0919175144-2017"&subject="Test"&body="Test Body"&total_fee="0.01"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&success="true"&sign_type="RSA"&sign="GeGoKwu4dRbVs5JpSJ8ZeOTqCgTab6RhA4mrrjwfRAQvzgAc88UXS2Vv5GIPAn+saW1LncrngFNXw2wBvnAx6+5CFQaCrW2sBxOOVk7578gjQJMuVXxXbz/B+7KvHdvpMKJPl+bN3PMXWOBcKnwMq9ldlXYzwO9wVn5sffIsmPI="}

			
			Log.d("Pay Response", result);
			
			PayResult payResult = new PayResult((String) result);
			/**
			 * 同步返回的结果必须放置到服务端进行验证（验证的规则请看https://doc.open.alipay.com/doc2/
			 * detail.htm?spm=0.0.0.0.xdvAU6&treeId=59&articleId=103665&
			 * docType=1) 建议商户依赖异步通知
			 */
			String resultInfo = payResult.getResult();// 同步返回需要验证的信息

			String resultStatus = payResult.getResultStatus();
			
			Message msg = new Message();
			msg.what = SDK_PAY_FLAG;
			msg.obj = result;
			mHandler.sendMessage(msg);
			
		}
	}
	
	private Handler mHandler = new Handler() {
		@SuppressWarnings("unused")
		public void handleMessage(Message msg) {
			
			switch (msg.what) {
			case SDK_PAY_FLAG: {
				PayResult payResult = new PayResult((String) msg.obj);
			
				/**
				 * 同步返回的结果必须放置到服务端进行验证（验证的规则请看https://doc.open.alipay.com/doc2/
				 * detail.htm?spm=0.0.0.0.xdvAU6&treeId=59&articleId=103665&
				 * docType=1) 建议商户依赖异步通知
				 */
				String resultInfo = payResult.getResult();// 同步返回需要验证的信息

				String resultStatus = payResult.getResultStatus();
				// 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
				if (TextUtils.equals(resultStatus, "9000")) {
					Toast.makeText(Main.ctx, "("+payResult.getResultMap().get("subject")+")支付成功", Toast.LENGTH_SHORT).show();
				} else {
					// 判断resultStatus 为非"9000"则代表可能支付失败
					// "8000"代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
					if (TextUtils.equals(resultStatus, "8000")) {
						Toast.makeText(Main.ctx, "("+payResult.getResultMap().get("subject")+")支付结果确认中", Toast.LENGTH_SHORT).show();

					} else {
						// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
						Toast.makeText(Main.ctx, "("+payResult.getResultMap().get("subject")+")支付失败", Toast.LENGTH_SHORT).show();
						
						//send the fail message to server to update the status's of the order

					}
				}
				if(callback!=null && !callback.equals(""))
				{
					String cb=StringUtil.addParameter(callback, resultStatus);
					LuaContext.getInstance().doString(callback);
				}
				break;
			}
			default:
				break;
			}
		};
	};


}
