package com.lohool.ola.wedgit;

import android.graphics.*;
import android.graphics.drawable.*;
import android.graphics.drawable.shapes.RoundRectShape;
import android.graphics.drawable.shapes.Shape;

public class IBorder extends ShapeDrawable {
	 private Paint fillpaint, strokepaint=null;
	public IBorder(int fillColor,int borderColor, int strokeWidth,int radius) {
/*
		float[] outerRadii = {20, 20, 40, 40, 60, 60, 80, 80};//外矩形 左上、右上、右下、左下 圆角半径  
		//float[] outerRadii = {20, 20, 20, 20, 20, 20, 20, 20};//外矩形 左上、右上、右下、左下 圆角半径  
		RectF inset = new RectF(100, 100, 200, 200);//内矩形距外矩形，左上角x,y距离， 右下角x,y距离  
		float[] innerRadii = {20, 20, 20, 20, 20, 20, 20, 20};//内矩形 圆角半径  
		//RoundRectShape roundRectShape = new RoundRectShape(outerRadii, inset, innerRadii);  
*/
	    super(new RoundRectShape(new float[] { radius, radius, radius, radius, radius, radius, radius, radius }, null, null));
	    fillpaint = new Paint(this.getPaint());
	    fillpaint.setColor(fillColor);
	    if(strokeWidth>0)
	    {
	    strokepaint = new Paint(fillpaint);
	    strokepaint.setStyle(Paint.Style.STROKE);
	    strokepaint.setStrokeWidth(strokeWidth);
	    strokepaint.setColor(borderColor);
	    }
	}



	@Override
	protected void onDraw(Shape shape, Canvas canvas, Paint paint) {
	    shape.draw(canvas, fillpaint);
	    if(strokepaint!=null)shape.draw(canvas, strokepaint);
	}
}