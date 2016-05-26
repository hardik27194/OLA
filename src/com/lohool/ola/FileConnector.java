package com.lohool.ola;

import java.io.*;
import java.util.*;

import org.keplerproject.luajava.JavaFunction;
import org.keplerproject.luajava.LuaException;
import org.keplerproject.luajava.LuaState;
import org.keplerproject.luajava.LuaStateFactory;

import com.lohool.ola.wedgit.Layout;

import android.app.Activity;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.LinearLayout;

public class FileConnector extends Activity {

	public static final int TYPE_DIRECTORY = 1;
	public static final int TYPE_FILE = 2;
	private int selectType = 2;
	private ConfirmListener listener;
	// private FileConnection fileConnection;
	private String parent;
	/**
	 * which type files should be listed,"*" means all the files. if the select
	 * type is DIRECTORY, the filter will be unavaiable.
	 */
	private String[] filter;

	private String absolutePath = "";

	Layout layout;
	
	private LuaState lua;
	
	/**
	 * Constractor
	 * 
	 * @param parent
	 *            initialized partent directory, if it is null, the file opener
	 *            will open the parent directory defaultly.
	 * @param filter
	 *            file filter
	 * @param selectType
	 *            indicate it is a file openner or a direcory openner.
	 */
	public FileConnector(String parent, String[] filter, int selectType) {
		// super("File Opener");
		// super("File Opener", List.IMPLICIT);
		this.parent = parent;
		this.selectType = selectType;
		this.filter = filter;

	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
//		String[] files;
//		if (parent == null) {
//			files = listRoot();
//		} else {
//			files = list(parent);
//		}
//		layout = new LinearLayout(this);
//		param = new LinearLayout.LayoutParams(
//				LinearLayout.LayoutParams.WRAP_CONTENT,
//				LinearLayout.LayoutParams.WRAP_CONTENT);
//		param.setLayoutDirection(LinearLayout.VERTICAL);
//		layout.setLayoutParams(param);
		
		/*
		lua = LuaStateFactory.newLuaState();

		lua.openLibs();

		try {
			lua.pushObjectValue(Log.class);
			lua.setGlobal("Log");
			lua.pushObjectValue(new UIFactory(this,lua));
			lua.setGlobal("ui");
		} catch (LuaException e) {
			e.printStackTrace();
		}
		
		loadXMLActivity();
        */

	}
	public void registReloadFun()
    {
    	Layout layout=null;
    	try {
    	lua.newTable(); 
        lua.pushValue(-1);
    	lua.setGlobal("sys");     	 
    	lua.pushString("reload");		
			lua.pushJavaFunction(new JavaFunction(lua){
				@Override
				public int execute() throws LuaException {
					loadXMLActivity();
					return 0;
				}});
		
		lua.setTable(-3);
    	} catch (LuaException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    void loadXMLActivity()
    {
//    	UIFactory ui= new UIFactory(this,lua);
//    	Layout layout=ui.loadXML("http://10.0.2.2:8080/test/testLua1.xml");
//    	this.setContentView(layout.getView());
    }
    
	// protected void keyPressed(int keyCode)
	// {
	//
	// }
	public void addListener(ConfirmListener listener) {
		this.listener = listener;
	}

	private String preSelected = "..";
/*
	protected void onclicked(int selectedIndex) {
		String fileName = this.getString(selectedIndex);
		// if (preSelected.equals(fileName))
		{
			pathNavigation(fileName, false);
			preSelected = "..";
		}
		// else
		// {
		// preSelected = fileName;
		// }
	}

	private void pathNavigation(String fileName, boolean isCommandOKPressed) {
		if (fileName.equals("..")) {
			// System.out.println(absolutePath);
			// remove the last char, the char is '/'
			absolutePath = absolutePath.substring(0, absolutePath.length() - 2);
			// is there exist another char '/'
			int pos = absolutePath.lastIndexOf('/');
			if (pos <= 0) {
				// when there is no more char '/',return to root
				absolutePath = "";
				displayItems(listRoot());
			} else {
				// get the parent of the current dir
				absolutePath = absolutePath.substring(0, pos + 1);
				displayItems(list(absolutePath));
			}
		} else {
			try {
				FileConnection file = (FileConnection) Connector.open(
						"file:///" + absolutePath + fileName, Connector.READ);
				if (file.isDirectory()) {
					if (isCommandOKPressed && selectType == TYPE_DIRECTORY) {
						listener.ok(absolutePath + fileName);
					} else {
						// list the current's sub files
						absolutePath += fileName;
						displayItems(list(absolutePath));
					}

				} else {
					if (isCommandOKPressed && selectType == TYPE_FILE) {
						listener.ok(absolutePath + fileName);
					}
				}
			} catch (IOException ex) {

				ex.printStackTrace();
			}
		}
	}

	public File getSDRootPath() {
		File sdDir = null;
		boolean sdCardExist = Environment.getExternalStorageState().equals(
				android.os.Environment.MEDIA_MOUNTED); // 判断sd卡是否存在
		if (sdCardExist) {
			sdDir = Environment.getExternalStorageDirectory();// 获取跟目录
		}
		return sdDir;

	}
*/
	/**
	 * is a file will be listed or not
	 * 
	 * @param file
	 * @return
	 */
	boolean isListedFileType(String file) {
		if (filter == null) {
			return true;
		}
		int pos = file.lastIndexOf('.');
		if (pos < 0) {
			return false;
		}
		String ext = "*." + file.substring(pos + 1);
		// System.out.println(ext);
		for (int i = 0; i < filter.length; i++) {
			if (filter[i].equals("*")) {
				return true;
			}
			if (filter[i].equalsIgnoreCase(ext)) {
				return true;
			}
		}
		return false;
	}
	public static String getSDRoot()
	{
		return android.os.Environment.getRootDirectory().getAbsolutePath();
	}
	public static String listFiles(String path)
	{
		return listFiles(path,"");
	}
	public static String listFiles(String path,String filters) {
		StringBuffer buf=new StringBuffer();
		final String[] fs;
		if(filters!=null)fs=filters.split(",");
		else fs=null;
		 FileFilter filefilter = new FileFilter() {
		        public boolean accept(File file) {
		        	if (fs==null) return true;
		            for(String ext:fs)
		            {
			            if (file.getName().toLowerCase().endsWith(ext.toLowerCase())) {
			                return true;
			            }
		            }
		            return false;
		        }
		    };
		    
		    File[] allFiles ;
		    if (fs==null) allFiles= new File(path).listFiles(); 
		    else allFiles= new File(path).listFiles(filefilter); 
		    
		    for (int i = 0; i < allFiles.length; i++) { 
		        File file = allFiles[i]; 
		        if (file.isFile()) { 
		        	buf.append("{");
		        	buf.append("name=\"").append(file.getName()).append("\"");
		        	buf.append(",");
		        	buf.append("type=\"1\"");
		        	buf.append("}");
					buf.append(",");
		            
		        } else  { 
		        	buf.append("{");
		        	buf.append("name=\"").append(file.getName()).append("\"");
		        	buf.append(",");
		        	buf.append("type=\"2\"");
		        	buf.append("}");
					buf.append(",");
		        } 
		    } 
		    buf.deleteCharAt(buf.length()-1);
		return buf.toString();
	}
/*
	public final String[] list(String parent) {
		Vector vector = null;
		String as[] = null;
		parent = "file:///" + parent;
		FileConnection fileConnection = null;
		vector = new Vector();
		try {
			fileConnection = (FileConnection) Connector.open(parent,
					Connector.READ);
		} catch (IOException e) {
			e.printStackTrace();
			vector.addElement(e.toString());
		}

		if (fileConnection != null) {
			try {
				Enumeration enumeration = fileConnection.list();

				while (enumeration.hasMoreElements()) {
					String fileName = (String) enumeration.nextElement();
					if (fileName.startsWith("."))
						continue;
					try {
						FileConnection file = (FileConnection) Connector.open(
								"file:///" + absolutePath + fileName,
								Connector.READ);

						if (file.isDirectory()) {
							vector.addElement(fileName);
						} else if (selectType == TYPE_FILE
								&& isListedFileType(fileName)) {
							vector.addElement(fileName);
						}
					} catch (Exception e) {
						continue;
					}

				}

			} catch (Exception exception) {
				System.out.println("Open connection  to '" + parent
						+ "' failed: " + exception.getMessage());
				exception.printStackTrace();
				vector.addElement(exception.toString());
			}
			try {
				fileConnection.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			fileConnection = null;
		}
		as = new String[vector.size()];
		vector.copyInto(as);
		return as;
	}
*/
}
