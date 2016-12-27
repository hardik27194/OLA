package com.lohool.ola.wedgit;

import org.w3c.dom.Node;

import android.content.Context;
import android.view.ViewGroup.LayoutParams;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.lohool.ola.Main;
import com.lohool.ola.R;
import com.lohool.ola.UIFactory;

public class BaiDuMap extends IWedgit
{
	public BaiDuMap(IView parent, Context context, Node root,UIFactory ui)
	{
		super(parent, context, root,ui);
		mapView =new MapView(Main.activity);
		v=mapView;
		super.initiate();
		//mapView.setGravity(css.getGravity());
		show();
	}

	public LocationClient locationClient = null;
	public MapView mapView = null;
	public BaiduMap baiduMap = null;
	boolean isFirstLoc = true;// 是否首次定位
	
	MyLocationData locData;
	
	BDLocationListener myListener = new BDLocationListener() {
		@Override
		public void onReceiveLocation(BDLocation location) {
			// map view 销毁后不在处理新接收的位置
			if (location == null || mapView == null)
				return;
			
			locData = new MyLocationData.Builder()
					.accuracy(location.getRadius())
					// 此处设置开发者获取到的方向信息，顺时针0-360
					.direction(100).latitude(location.getLatitude())
					.longitude(location.getLongitude()).build();
			
			System.out.println("----location-------------------");
			System.out.println("latitude="+locData.latitude);
			System.out.println("longitude="+locData.longitude);
			
			
			baiduMap.setMyLocationData(locData);	//设置定位数据
			
			
			if (isFirstLoc) {
				isFirstLoc = false;
				
				
				LatLng ll = new LatLng(location.getLatitude(),
						location.getLongitude());
				MapStatusUpdate u = MapStatusUpdateFactory.newLatLngZoom(ll, 16);	//设置地图中心点以及缩放级别
//				MapStatusUpdate u = MapStatusUpdateFactory.newLatLng(ll);
				baiduMap.animateMapStatus(u);
				
				
			}
			//stop location service
			locationClient.stop();
		}


		
		public void onReceivePoi(BDLocation arg0)
		{
			System.out.println("----received POI-------------------");
			
		}
	};

	public double getlatitude()
	{
		return locData.latitude;
	}
	public double getLongitude()
	{
		return locData.longitude;
	}
	
	
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
	

	/**
	 * set map's center location
	 * @param latitude
	 * @param longitude
	 */
	public void locate(double latitude, double longitude)
	{
		LatLng cenpt = new LatLng(29.806651,121.606983); 
        //定义地图状态
       MapStatus mMapStatus = new MapStatus.Builder()
        .target(cenpt)
        .zoom(18)
        .build();
        //定义MapStatusUpdate对象，以便描述地图状态将要发生的变化


       MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mMapStatus);
        //改变地图状态
       baiduMap.setMapStatus(mMapStatusUpdate); 
	}
	
	public void mark(double latitude, double longitude)
	{
		//定义Maker坐标点  
		LatLng point = new LatLng(39.963175, 116.400244);  
		//构建Marker图标  
		BitmapDescriptor bitmap = BitmapDescriptorFactory
		    .fromResource(R.drawable.map_maker);  
		//构建MarkerOption，用于在地图上添加Marker  
		OverlayOptions option = new MarkerOptions()  
		    .position(point)  
		    .icon(bitmap);  
		//在地图上添加Marker，并显示  
		baiduMap.addOverlay(option);
	}
	
	public void show()
	{
//        LayoutParams p1 = new LayoutParams(
//        		LayoutParams.MATCH_PARENT,
//        		LayoutParams.MATCH_PARENT);
//        mapView.setLayoutParams(p1);
        baiduMap= mapView.getMap();
        baiduMap.setTrafficEnabled(true);
		baiduMap.setMyLocationEnabled(true);
		
		locate();
		
        //Main.activity.setContentView(mapView);
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
}
