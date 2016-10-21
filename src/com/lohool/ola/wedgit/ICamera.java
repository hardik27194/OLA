package com.lohool.ola.wedgit;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import com.lohool.ola.Main;
import com.lohool.ola.R;
import com.lohool.ola.util.ImageTool;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout.LayoutParams;

public class ICamera extends Activity {
	
	private static final int TAKE_PICTURE = 0;
	private static final int CHOOSE_PICTURE = 1;
	
	private static final int SCALE = 1;//照片缩小比例
	private ImageView iv_image = null;
	
	String albumPath;
	
	String photoPath;
	String luaCallback;
	
    public static void openCamera(String albumPath,String callback)
    {
    	
        /* 新建一个Intent对象 */
        Intent intent = new Intent();
        intent.putExtra("albumPath",albumPath);   
        intent.putExtra("luaCallback",callback);
        /* 指定intent要启动的类 */
        intent.setClass(Main.activity, ICamera.class);
        /* 启动一个新的Activity */
        Main.activity.startActivityForResult(intent,1000);
        /* 关闭当前的Activity */
        //Activity01.this.finish();
    }

    
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		setTitle("Camera");
		Intent intent =getIntent();
		this.albumPath=intent.getStringExtra("albumPath");
		this.luaCallback=intent.getStringExtra("luaCallback");

		/*
		ImageView imageView = new ImageView(this.getApplicationContext());

	     // 设置当前图像的图像（position为当前图像列表的位置）

	     //imageView.seti.setImageResource(resIds[position]);
	     

	     imageView.setScaleType(ImageView.ScaleType.FIT_XY);
	     imageView.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.WRAP_CONTENT));


	    // 设置Gallery组件的背景风格

	    //imageView.setBackgroundResource(mGalleryItemBackground);
	    
	    
		iv_image = imageView;
		*/
		showPicturePicker(ICamera.this);		

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		System.out.println("cam.requestCode="+requestCode);
		System.out.println("cam.resultCode="+resultCode);
		if (resultCode == RESULT_OK) {
			switch (requestCode) {
			case TAKE_PICTURE:
				//将保存在本地的图片取出并缩小后显示在界面上
//				Bitmap bitmap = BitmapFactory.decodeFile(this.albumPath+"/OLA_CAM_TEMP.jpg");
//				//Bitmap newBitmap = ImageTool.zoomBitmap(bitmap, bitmap.getWidth() / SCALE, bitmap.getHeight() / SCALE);
//				//由于Bitmap内存占用较大，这里需要回收内存，否则会报out of memory异常
//				//bitmap.recycle();
//				
//				//将处理过的图片显示在界面上，并保存到本地
//				if(iv_image!=null)iv_image.setImageBitmap(bitmap);
//				this.photoPath=ImageTool.savePhotoToSDCard(bitmap, this.albumPath, String.valueOf(System.currentTimeMillis()));
				this.photoPath=this.albumPath+String.valueOf(System.currentTimeMillis())+".jpg";
				new File(this.albumPath+"/OLA_CAM_TEMP.jpg").renameTo(new File(photoPath));
				//this.photoPath=this.albumPath+"/OLA_CAM_TEMP.jpg";
				System.out.println("cam.luaCallback="+luaCallback+"(\""+this.photoPath+"\")");
				 Intent intent = new Intent();
				 intent.putExtra("luaCallback", luaCallback+"(\""+this.photoPath+"\")");
	             setResult(1001, intent);
	             System.out.println("cam.luaCallback="+luaCallback);
				break;

			case CHOOSE_PICTURE:
				ContentResolver resolver = getContentResolver();
				//照片的原始资源地址
				Uri originalUri = data.getData(); 
				this.photoPath=originalUri.getPath();
	            try {
	            	//使用ContentProvider通过URI获取原始图片
					Bitmap photo = MediaStore.Images.Media.getBitmap(resolver, originalUri);
					if (photo != null) {
						//为防止原始图片过大导致内存溢出，这里先缩小原图显示，然后释放原始Bitmap占用的内存
						Bitmap smallBitmap = ImageTool.zoomBitmap(photo, photo.getWidth() / SCALE, photo.getHeight() / SCALE);
						//释放原始图片占用的内存，防止out of memory异常发生
						photo.recycle();
						
						if(iv_image!=null)iv_image.setImageBitmap(smallBitmap);
					}
					
					Intent intent1 = new Intent();
		             intent1.putExtra("luaCallback", luaCallback+"('"+this.photoPath+"')");
		             setResult(1001, intent1);
					
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}  
				break;
			
			default:
				break;
			}
		}
		finish();
	}
	
	public void showPicturePicker(Context context){
		AlertDialog.Builder builder = new AlertDialog.Builder(context);
		builder.setTitle("图片来源");
		builder.setItems(new String[]{"拍照","相册"}, new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				System.out.println("cam.select.which="+which);
				System.out.println("cam.select.albumPath="+albumPath);
				File f=new File(albumPath);
				if(!f.exists())f.mkdirs();
				switch (which) {
				case TAKE_PICTURE:
					Intent openCameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
					Uri imageUri = Uri.fromFile(new File(albumPath,"OLA_CAM_TEMP.jpg"));
					//指定照片保存路径（SD卡），image.jpg为一个临时文件，每次拍照后这个图片都会被替换
					openCameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
					startActivityForResult(openCameraIntent, TAKE_PICTURE);
					break;
					
				case CHOOSE_PICTURE:
					Intent openAlbumIntent = new Intent(Intent.ACTION_GET_CONTENT);
					openAlbumIntent.setType("image/*");
					startActivityForResult(openAlbumIntent, CHOOSE_PICTURE);
					break;

				default:
					break;
				}
			}
		});
		builder.setNegativeButton("取消",new DialogInterface.OnClickListener() {

			 @Override
			 public void onClick(DialogInterface dialog, int which)
			 {
				 finish();
			 } 
			 }
		);
		
		builder.create().show();
	}
}
