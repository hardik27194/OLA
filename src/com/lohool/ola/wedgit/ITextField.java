package com.lohool.ola.wedgit;


import org.w3c.dom.Node;

import com.lohool.ola.UIFactory;

import android.content.Context;
import android.text.InputType;
import android.text.method.PasswordTransformationMethod;
import android.widget.Button;
import android.widget.EditText;

public class ITextField extends IWedgit {
	  // Field descriptor #4 I
	  public static final int TYPE_MASK_CLASS = 15;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_MASK_VARIATION = 4080;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_MASK_FLAGS = 16773120;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_NULL = 0;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_CLASS_TEXT = 1;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_CAP_CHARACTERS = 4096;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_CAP_WORDS = 8192;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_CAP_SENTENCES = 16384;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_AUTO_CORRECT = 32768;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_AUTO_COMPLETE = 65536;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_MULTI_LINE = 131072;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_IME_MULTI_LINE = 262144;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_FLAG_NO_SUGGESTIONS = 524288;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_NORMAL = 0;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_URI = 16;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_EMAIL_ADDRESS = 32;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_EMAIL_SUBJECT = 48;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_SHORT_MESSAGE = 64;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_LONG_MESSAGE = 80;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_PERSON_NAME = 96;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_POSTAL_ADDRESS = 112;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_PASSWORD = 128;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_VISIBLE_PASSWORD = 144;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_WEB_EDIT_TEXT = 160;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_FILTER = 176;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_PHONETIC = 192;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_WEB_EMAIL_ADDRESS = 208;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_TEXT_VARIATION_WEB_PASSWORD = 224;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_CLASS_NUMBER = 2;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_NUMBER_FLAG_SIGNED = 4096;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_NUMBER_FLAG_DECIMAL = 8192;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_NUMBER_VARIATION_NORMAL = 0;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_NUMBER_VARIATION_PASSWORD = 16;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_CLASS_PHONE = 3;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_CLASS_DATETIME = 4;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_DATETIME_VARIATION_NORMAL = 0;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_DATETIME_VARIATION_DATE = 16;
	  
	  // Field descriptor #4 I
	  public static final int TYPE_DATETIME_VARIATION_TIME = 32;

	public ITextField(IView parent, Context context, Node root,UIFactory ui) {
		super(parent, context, root,ui);
		EditText t = new EditText(context);
		v=t;
		super.initiate();
		t.setGravity(css.getGravity());
	}

	public void setInputType(int classType, int type) {
		System.out.println("ITextField.setInputType is executed");
		EditText t=((EditText) v);
		t.setInputType(classType | type);
		t.setTransformationMethod(PasswordTransformationMethod.getInstance());
	}
	
}
