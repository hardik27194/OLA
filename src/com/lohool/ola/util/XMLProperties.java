package com.lohool.ola.util;


import java.io.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.w3c.dom.*;
import org.w3c.*;
import org.xml.sax.*;
import org.xml.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMSource;

/**
 * <p>manage xml properties,if can be come from file or a pointed root Element</p>
 * <p>Copyright: Copyright (c) 2003</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */


public class XMLProperties
{
    private File file;
    private Document doc;

    Element element;
    String charset="utf-8";


     public XMLProperties(String xmlString) throws IOException
     {
         Reader reader = null;
         try
         {
             reader = new InputStreamReader(new ByteArrayInputStream(xmlString.getBytes()));
             DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
             DocumentBuilder db = dbf.newDocumentBuilder();
             doc = db.parse(new InputSource(reader));
             element = doc.getDocumentElement();

         }
         catch (Exception e)
         {
             throw new IOException(e.getMessage());
         }
         finally
         {
             try
             {
                 reader.close();
             }
             catch (Exception e)
             {}
         }
     }
    public XMLProperties(String fileName,String charset) throws IOException
    {
        file = new File(fileName);
        this.charset=charset;
        if (!file.exists())
        {
            File tempFile = new File(file.getParentFile(),file.getName() + ".tmp");
            if (tempFile.exists())
            {
                //Log.error("WARNING: " + fileName + " was not found, but temp file from " + "previous write operation was. Attempting automatic recovery. Please " + "check file for data consistency.");
                tempFile.renameTo(file);
            }
            else
            {
                throw new FileNotFoundException(
                    "XML properties file does not exist: " + fileName);
            }
        }
        if (!file.canRead())
        {
            throw new IOException("XML properties file must be readable: " +
                                  fileName);
        }
        if (!file.canWrite())
        {
            throw new IOException("XML properties file must be writable: " +
                                  fileName);
        }

        Reader reader = null;
        try
        {
            reader = new InputStreamReader(new FileInputStream(file), charset);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            doc = db.parse(new InputSource(reader));
            element = doc.getDocumentElement();

        }
        catch (Exception e)
        {
            e.printStackTrace() ;
            //Log.error("Error creating XML properties file " + fileName + ".", e);
            throw new IOException(e.getMessage());
        }
        finally
        {
            try
            {
                reader.close();
            }
            catch (Exception e)
            {}
        }
    }
public XMLProperties(InputStream is) throws IOException
    {

        Reader reader = null;
        try
        {
            reader = new InputStreamReader(is);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            doc = db.parse(new InputSource(reader));
            element = doc.getDocumentElement();

        }
        catch (Exception e)
        {
            e.printStackTrace() ;
            //Log.error("Error creating XML properties file " + fileName + ".", e);
            throw new IOException(e.getMessage());
        }
        finally
        {
            try
            {
                reader.close();
            }
            catch (Exception e)
            {}
        }
    }

    /**
     * get properties from a pointed Element
     * @param root
     */
    public XMLProperties(Element root)
    {
		this.doc=root.getOwnerDocument();
        this.element = root;
    }

    public synchronized Element getChild(String name)
    {
        return getChild(element, name);
    }


    public synchronized ArrayList getSubTags(String name)
    {
        return getSubTags(element, name);
    }

    /*
        public String[] getChildrenProperties(String parent)
        {
            String propName[] = parsePropertyName(parent);
            Element element = doc.getRootElement();
            for(int i = 0; i < propName.length; i++)
            {
                element = element.getChild(propName[i]);
                if(element == null)
                    return new String[0];
            }
            List children = element.getChildren();
            int childCount = children.size();
            String childrenNames[] = new String[childCount];
            for(int i = 0; i < childCount; i++)
                childrenNames[i] = ((Element)children.get(i)).getName();
            return childrenNames;
        }
     */
    /**
     * Warning:the name will be cashed,so if the Element is not equaled
     * but the name is equaled with last,you will get the wrong return
     * value(it will return the last value which found at last Element)
     * @param element
     * @param name
     * @return
     */
    /*
     //does not use xalan to implement the getPoperty() method
         public static String getProperty(Element element, String name)
         {
        String value = null;
        if (element == null)
        {
            return null;
        }
        Element node = (Element) element.cloneNode(true);
        // String propName[] = parsePropertyName(name);
        Object[] URIName; //= name.split(".");
        List propName = new ArrayList(5);
        for (StringTokenizer tokenizer = new StringTokenizer(name, ".");
             tokenizer.hasMoreTokens(); propName.add(tokenizer.nextToken()))
        {
            ;
        }
        URIName = propName.toArray();
        for (int i = 0; i < URIName.length; i++)
        {
            //System.out .println("::::"+(String)URIName[i]) ;
            node = XMLToolkit.getChild(node, (String) URIName[i]);
            if (node == null)
            {
                return null;
            }
        }
         value = XMLToolkit.getTxtNodeValue(node); // node.getNodeValue(); //.toString();
        //System.out .println("value:::"+value) ;
        if ("".equals(value))
        {
            return null;
        }
        else
        {
            value = value.trim();
            return value;
        }
         }
     */
   
    public static Element getChild(Element element, String name)
    {
        String value = null;
        if (element == null)
        {
            return null;
        }
        Element node = (Element) element.cloneNode(true);

        // String propName[] = parsePropertyName(name);
        Object[] URIName; //= name.split(".");
        List propName = new ArrayList(5);
        for (StringTokenizer tokenizer = new StringTokenizer(name, ".");
             tokenizer.hasMoreTokens(); propName.add(tokenizer.nextToken()))
        {
            ;
        }
        URIName = propName.toArray();
        for (int i = 0; i < URIName.length; i++)
        {
            
            node = XMLToolkit.getChild(node, (String) URIName[i]);
            //System.out.print("Node name::"+node.getNodeName());
            if (node == null)
            {
                return null;
            }
        }
        return node;
    }
    public static ArrayList getSubTags(Element element, String name)
    {
        ArrayList list=new ArrayList();
        Element node = getChild(element,name);
        NodeList nl = node.getChildNodes();
        for (int i = 0; i < nl.getLength(); i++)
        {
            Node n = nl.item(i);
            if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
            {
                list.add(n.getNodeName());
            }
        }
        return list;
    }

    /**
     * get Element property
     * @param XPath
     * @param childXPath
     * @param childValue
     * @return
     */
    public synchronized Element getProperty(String XPath, String childXPath,
                                            String childValue)
    {
        return XMLToolkit.getChild(element, XPath, childXPath, childValue);
    }



    /**
     * save the properties
     */
    public synchronized void saveProperties()
    {
        Writer writer = null;
        boolean error = false;
        File tempFile = null;
        DOMSource source;
        StreamResult result;

        try
        {
            //use temp file to test whether can save properties
            source = new DOMSource(doc);
            tempFile = new File(file.getParentFile(), file.getName() + ".tmp");
            TransformerFactory ft = TransformerFactory.newInstance();
            Transformer tf = ft.newTransformer();
            //XMLOutputter outputter = new XMLOutputter("    ", true);
            writer = new OutputStreamWriter(new FileOutputStream(tempFile),charset);
            //outputter.output(doc, writer);
            result = new StreamResult(writer);
            tf.transform(source, result);

            /*
                //����һ��transformer
                TransformerFactory tFactory = TransformerFactory.newInstance();
                DOMSource doms = new DOMSource (doc);
                Transformer transformer = tFactory.newTransformer();
                StringReader reader =new StringReader("<?xml version=\"1.0\"?> <doc/>");
                StringWriter writer=new StringWriter();
                //����޸ĺ��xsl�������StringWriter
                transformer.transform(doms,new StreamResult(writer));

                //���xsl���������������ݿ��ѯ����xml�ĵ�
                Transformer transformer1 = tFactory.newTransformer(
                    new StreamSource(new StringReader(writer.toString())));
                //��������Ϊ"result.xml"��xml�ļ���
                transformer1.transform(new StreamSource(reader),
                    new StreamResult(new FileOutputStream("result.xml")));
*/
        }
        catch (Exception e)
        {
            //e.printStackTrace() ;
            //Log.error(e);
            error = true;
        }
        finally
        {
            try
            {
                writer.close();
            }
            catch (Exception e)
            {
                //e.printStackTrace() ;
                //Log.error(e);
                error = true;
            }
        }
        if (!error)
        {
            error = false;
            if (file.exists() && !file.delete())
            {
                //Log.error("Error deleting property file: " + file.getAbsolutePath());
                return;
            }
            try
            {
                source = new DOMSource(doc);
                TransformerFactory ft = TransformerFactory.newInstance();
                Transformer tf = ft.newTransformer();
                //XMLOutputter outputter = new XMLOutputter("    ", true);
                writer = new OutputStreamWriter(new FileOutputStream(file),charset);
                //outputter.output(doc, writer);
                result = new StreamResult(writer);
                tf.transform(source, result);

            }
            catch (Exception e)
            {
                //Log.error(e);
                error = true;
            }
            finally
            {
                try
                {
                    writer.close();
                }
                catch (Exception e)
                {
                    //Log.error(e);
                    error = true;
                }
            }
            if (!error)
            {
                tempFile.delete();
            }
        }
    }

    private String[] parsePropertyName(String name)
    {
        List propName = new ArrayList(5);
        for (StringTokenizer tokenizer = new StringTokenizer(name, ".");
             tokenizer.hasMoreTokens(); propName.add(tokenizer.nextToken()))
        {
            ;
        }
        return (String[]) propName.toArray(new String[propName.size()]);
    }

    public static String parseTextXPath(String name)
    {
        name = name.replace('.', '/');
        name = "" + name + "/text()";
        return name;
    }
    public static String parseNodeXPath(String name)
    {
        name = name.replace('.', '/');
        return name;
    }
    public Element getRootElement()
    {
        return this.element ;
    }
    /*
        public String getRootName()
        {
            Node node = null;
            try
            {
                node = XPathAPI.selectSingleNode(element, "/*");
              }
              catch (Exception e)
              {
                  e.printStackTrace();
                  return null;
              }
              if (node == null)
              {
                  return null;
              }
              return node.getNodeName();
          }
      */
    
    public static void main(String[] arg)
    {
        try {
            XMLProperties xml=new XMLProperties("D:/apache-tomcat-5.5.33/webapps/ROOT/WEB-INF/config.xml");
            xml.getSubTags("security.users");
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}

