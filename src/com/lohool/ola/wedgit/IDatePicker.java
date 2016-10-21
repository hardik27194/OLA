package com.lohool.ola.wedgit;
/**
 * Date time picker dialog
 */

import java.util.Calendar;

import com.lohool.ola.LuaContext;
import com.lohool.ola.Main;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.widget.DatePicker;
import android.widget.TimePicker;

public class IDatePicker
{
	Calendar selected = Calendar.getInstance();
	/**
	 * lua callback function, will be called by lua while the button"Done" was pressed.
	 */
	String callback;
	public static int TYPE_DATE=1;
	public static int TYPE_TIME=2;
	int type;
	public IDatePicker(int type)
	{
		this.type=type;
		selected.setTimeInMillis(0);
	}

	public static IDatePicker create(int type)
	{

		return new IDatePicker(type);

	}
	public void onDone(String callback)
	{
		this.callback=callback;
	}
	public void open()
	{
		Dialog dialog = null;

		Calendar c = Calendar.getInstance();
		if(type==IDatePicker.TYPE_DATE)
		{
		dialog = new DatePickerDialog(Main.activity,
				new DatePickerDialog.OnDateSetListener()
				{
					@Override
					public void onDateSet(DatePicker dp, int year, int month,
							int dayOfMonth)
					{
						selected.set(Calendar.YEAR, year);
						selected.set(Calendar.MONTH, month);
						selected.set(Calendar.DAY_OF_MONTH, dayOfMonth);
						if(callback!=null)
						{
							UIMessage msg=new UIMessage();
							LuaContext lua=LuaContext.getInstance();
		            		lua.regist(new ICalendar(selected), "calendar");
		            	    msg.updateMessage(callback+"(calendar)");
		            	    lua.remove("calendar");
						}
						
					}

				}, c.get(Calendar.YEAR), // 传入年份
				c.get(Calendar.MONTH), // 传入月份
				c.get(Calendar.DAY_OF_MONTH) // 传入天数
				
		);
		}
		else if(type==IDatePicker.TYPE_TIME)
		{
		dialog = new TimePickerDialog(Main.activity,
				new TimePickerDialog.OnTimeSetListener()
				{
					@Override
					public void onTimeSet(TimePicker dp, int hour, int minute)
					{
						selected.set(Calendar.HOUR_OF_DAY, hour);
						selected.set(Calendar.MINUTE, minute);
						if(callback!=null)
						{
							UIMessage msg=new UIMessage();
							LuaContext lua=LuaContext.getInstance();
		            		lua.regist(new ICalendar(selected), "calendar");
		            	    msg.updateMessage(callback+"(calendar)");
		            	    lua.remove("calendar");
						}
						
					}


				}, c.get(Calendar.HOUR_OF_DAY), // 传入年份
				c.get(Calendar.MINUTE),
				true
		
		);
		}
		dialog.show();
	}
	class ICalendar
	{
		Calendar cal;
		public ICalendar(Calendar cal)
		{
			this.cal=cal;
		}
		public int getYear()
		{
			return cal.get(Calendar.YEAR);
		}
		public int getMonth()
		{
			return cal.get(Calendar.MONTH)+1;
		}
		public int getDayOfMonth()
		{
			return cal.get(Calendar.DAY_OF_MONTH);
		}
		public int getHour()
		{
			return cal.get(Calendar.HOUR_OF_DAY);
		}
		public int getMinute()
		{
			return cal.get(Calendar.MINUTE);
		}
		public int getSecond()
		{
			return cal.get(Calendar.SECOND);
		}
		public long getTime()
		{
			return cal.getTimeInMillis();
		}
	}

}
