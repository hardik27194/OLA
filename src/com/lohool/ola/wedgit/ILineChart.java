package com.lohool.ola.wedgit;

import java.util.ArrayList;

import org.w3c.dom.Node;

import android.content.Context;
import android.graphics.Color;



import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.XAxis.XAxisPosition;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.lohool.ola.UIFactory;

/**
 * Line chart
 * @author xingbao-
 *
 */

public class ILineChart extends IWedgit {
	LineChart lc;
	ArrayList<String> xValues = new ArrayList<String>();
	ArrayList<LineDataSet> lineDataSets = new ArrayList<LineDataSet>(); 
	
	
	public ILineChart(IView parent,Context context,Node root,UIFactory ui) {
		super(parent, context,  root,ui);
		lc=new LineChart(context);
		
		v=lc;
		
		super.initiate();
		//t.setGravity(css.getGravity());
		init();
	}

	
	private void init()
	{
	       /*
	        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
					MarginLayoutParams.WRAP_CONTENT,
					MarginLayoutParams.WRAP_CONTENT);
	        lc.setLayoutParams(params);
	        */
	        
		/*
		 * 
		 *lineChart.setDrawBorders(false);  //是否在折线图上添加边框    
37.    
38.        // no description text    
39.        lineChart.setDescription("");// 数据描述    
40.        // 如果没有数据的时候，会显示这个，类似listview的emtpyview    
41.        lineChart.setNoDataTextDescription("You need to provide data for the chart.");    
42.            
43.        // enable / disable grid background    
44.        lineChart.setDrawGridBackground(false); // 是否显示表格颜色    
45.        lineChart.setGridBackgroundColor(Color.WHITE & 0x70FFFFFF); // 表格的的颜色，在这里是是给颜色设置一个透明度    
46.    
47.        // enable touch gestures    
48.        lineChart.setTouchEnabled(true); // 设置是否可以触摸    
49.    
50.        // enable scaling and dragging    
51.        lineChart.setDragEnabled(true);// 是否可以拖拽    
52.        lineChart.setScaleEnabled(true);// 是否可以缩放    
53.    
54.        // if disabled, scaling can be done on x- and y-axis separately    
55.        lineChart.setPinchZoom(false);//     
56.    
57.        lineChart.setBackgroundColor(color);// 设置背景    
58.    
59.        // add data    
60.        lineChart.setData(lineData); // 设置数据    
61.    
62.        // get the legend (only possible after setting data)    
63.        Legend mLegend = lineChart.getLegend(); // 设置比例图标示，就是那个一组y的value的    
64.    
65.        // modify the legend ...    
66.        // mLegend.setPosition(LegendPosition.LEFT_OF_CHART);    
67.        mLegend.setForm(LegendForm.CIRCLE);// 样式    
68.        mLegend.setFormSize(6f);// 字体    
69.        mLegend.setTextColor(Color.WHITE);// 颜色    
70.//      mLegend.setTypeface(mTf);// 字体    
71.    
72.        lineChart.animateX(2500); // 立即执行的动画,x轴    


	        //设置最大值和最小值的标注线

	        LimitLine ll1 = new LimitLine(120f, "最大值");

	        ll1.setLineWidth(4f);

//	        ll1.enableDashedLine(10f, 10f, 0f);//设置为虚线。

	        ll1.setLabelPosition(LimitLabelPosition.LEFT_BOTTOM);

	        ll1.setTextSize(10f);

	 

	        LimitLine ll2 = new LimitLine(100f, "最小值");

	        ll2.setLineWidth(4f);

//	        ll2.enableDashedLine(10f, 10f, 0f);

	        ll2.setLabelPosition(LimitLabelPosition.LEFT_BOTTOM);

	        ll2.setTextSize(10f);
	        
	        
	        lineChart.getAxisRight().setEnabled(false); // 隐藏右边 的坐标轴
        lineChart.getXAxis().setPosition(XAxisPosition.BOTTOM); // 让x轴在下面
        lineChart.getXAxis().setGridColor(
                getResources().getColor(R.color.transparent));


	        */
		
		lc.setDragEnabled(false);
		lc.setTouchEnabled(false);
		//lc.animateX(3000); 
		lc.setDrawGridBackground(false);


		XAxis xAxis = lc.getXAxis();

        xAxis.setPosition(XAxisPosition.BOTTOM);

        //xAxis.setTypeface(mTf);

        xAxis.setDrawGridLines(false);

        //xAxis.setDrawAxisLine(true);
        xAxis.setDrawAxisLine(false);

	        //Y轴样式。

	        YAxis leftAxis = lc.getAxisLeft();

	        //leftAxis.setTypeface(mTf);

	        leftAxis.setLabelCount(10, false);

	        //leftAxis.addLimitLine(ll1);

	        //leftAxis.addLimitLine(ll2);
	        //leftAxis.setAxisMinValue(100);
	        //leftAxis.setAxisMaxValue(120);
	        leftAxis.enableGridDashedLine(10f, 10f, 0f);
	        leftAxis.setStartAtZero(false);
	        leftAxis.setDrawLabels(false);
	        leftAxis.setDrawTopYLabelEntry(false);
	        leftAxis.setDrawAxisLine(false);


	        YAxis rightAxis = lc.getAxisRight();

	        //leftAxis.setTypeface(mTf);

	        rightAxis.setLabelCount(10, false);
	        rightAxis.enableGridDashedLine(10f, 10f, 0f);
	        rightAxis.setStartAtZero(false);
	        rightAxis.setEnabled(false);
	        
	        
	        lc.setDescription("");

	}
	
	public void clear()
	{
		xValues.clear();
		lineDataSets.clear();
	}
	public void setXValue(String  xValue)
	{
		String[] xv=xValue.split(",");
		for (int i = 0; i < xv.length; i++) {    
            xValues.add(xv[i]);  
            //System.out.println(xv[i]);
        } 
	}
	public void addYValue_withLabel(String yValue,String label)
	{
		String yv[] =yValue.split(",");
		ArrayList<Entry> yValues2 = new ArrayList<Entry>();  
        for (int i = 0; i < yv.length; i++) {     
            yValues2.add(new Entry(Float.parseFloat(yv[i]), i));  
            //System.out.println(yv[i]);
        }
		// y轴的数据集合    
        LineDataSet lineDataSet = new LineDataSet(yValues2, label /*显示在比例图上*/); 
        int color=Color.rgb((int)(Math.random() *255),(int)(Math.random() *255),(int)(Math.random() *255));
        lineDataSet.setFillColor(color);
        lineDataSet.setColor(color);
        lineDataSets.add(lineDataSet);
	}
	public void show()
	{
		LineData lineData1 = new LineData(xValues, lineDataSets);  //使用ArrayList设置生成数据。
        lc.setData(lineData1);
        lc.postInvalidate();
	}
}
