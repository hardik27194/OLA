package com.lohool.ola.util;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.MyLocationData;
import com.lohool.ola.Main;

import android.location.LocationListener;
import android.os.Bundle;





public class Location
{
	static Location loc=null;
	public LocationClient locationClient = null;
	boolean isFirstLoc = true;// 是否首次定位
	
	MyLocationData locData;
	
	BDLocationListener myListener = new BDLocationListener() {
		@Override
		public void onReceiveLocation(BDLocation location) {
			// map view 销毁后不在处理新接收的位置
			if (location == null )
				return;
			
			locData = new MyLocationData.Builder()
					.accuracy(location.getRadius())
					// 此处设置开发者获取到的方向信息，顺时针0-360
					.direction(100).latitude(location.getLatitude())
					.longitude(location.getLongitude()).build();

			
			
			if (isFirstLoc) {
				isFirstLoc = false;
			}
			//stop location service
			locationClient.stop();
		}


		
		public void onReceivePoi(BDLocation arg0)
		{
			System.out.println("----received POI-------------------");
			
		}
	};

	/**
	 *set  current location as the map's center
	 */
	public void locate()
	{
		locationClient = new LocationClient(Main.activity.getApplicationContext()); // 实例化LocationClient类
				
		locationClient.registerLocationListener(myListener); // 注册监听函数
		this.setLocationOption();	//设置定位参数
		locationClient.start(); // 开始定位
		locationClient.requestLocation();
	}
	
	public double getlatitude()
	{
		return locData.latitude;
	}
	public double getLongitude()
	{
		return locData.longitude;
	}

	
	private void setLocationOption() {
		LocationClientOption option = new LocationClientOption();
		option.setOpenGps(true); // 打开GPS
		option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);// 设置定位模式
		option.setCoorType("bd09ll"); // 返回的定位结果是百度经纬度,默认值gcj02
		option.setScanSpan(5000); // 设置发起定位请求的间隔时间为5000ms
		option.setIsNeedAddress(true); // 返回的定位结果包含地址信息
		option.setNeedDeviceDirect(true); // 返回的定位结果包含手机机头的方向
		
		locationClient.setLocOption(option);
	}
	
	
	private LocationListener locationListener=new LocationListener() {  
        
        /** 
         * 位置信息变化时触发 
         */  
        public void onLocationChanged(android.location.Location location) {  
//            Log.d(TAG, "经度："+location.getLongitude());   
//            Log.d(TAG, "纬度："+location.getLatitude());   
//            Log.d(TAG, "海拔："+location.getAltitude());   
        }  
          
        /** 
         * GPS状态变化时触发 
         */  
        public void onStatusChanged(String provider, int status, Bundle extras) {  
//            switch (status) {  
//            //GPS状态为可见时  
//            case LocationProvider.AVAILABLE:  
//                Log.d(TAG, "当前GPS状态为可见状态");  
//                break;  
//            //GPS状态为服务区外时  
//            case LocationProvider.OUT_OF_SERVICE:  
//                Log.d(TAG, "当前GPS状态为服务区外状态");  
//                break;  
//            //GPS状态为暂停服务时  
//            case LocationProvider.TEMPORARILY_UNAVAILABLE:  
//                Log.d(TAG, "当前GPS状态为暂停服务状态");  
//                break;  
//            }  
        }  
      
        /** 
         * GPS开启时触发 
         */  
        public void onProviderEnabled(String provider) {  
            //location=locationManager.getLastKnownLocation(provider);  
//            updateView(location);  
        }  
      
        /** 
         * GPS禁用时触发 
         */  
        public void onProviderDisabled(String provider) {  
//            updateView(null);  
        }


    };  
}
