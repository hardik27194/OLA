package com.example.anluatest.util;



/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2003</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */

import javax.xml.parsers.*;
import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.helpers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.sax.*;
import javax.xml.transform.stream.*;
import java.io.*;
import java.lang.reflect.*;

public class XMLToolkit
{
    public XMLToolkit()
    {
    }

    /**
     * transform a XML file to a named format by the XSLT file
     * @param xml xml file name
     * @param xsl xsl file name
     * @return
     */
    public static OutputStream filterXMLFile(String xml, String xsl)
    {
        OutputStream out = new ByteArrayOutputStream();
        try
        {
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformer = tFactory.newTransformer(new StreamSource(
                xsl));
            // Set the parameter. I can't get non-null namespaces to work!!
            transformer.setParameter("param1", "param");

            transformer.transform(new StreamSource(xml),
                                  new StreamResult(out));
        }
        catch (TransformerException ex)
        {
            ex.printStackTrace();
        }
        catch (TransformerFactoryConfigurationError ex)
        {
            ex.printStackTrace();
        }
        return out;
    }

    /**
     * transform a XML file to a named format by the XSLT file
     * @param xml
     * @param xsl
     * @return
     */
    public static OutputStream filterXML(String xml, String xsl)
    {
        OutputStream out = new ByteArrayOutputStream();
        try
        {
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformer = tFactory.newTransformer(new StreamSource(
                xsl));
            // Set the parameter. I can't get non-null namespaces to work!!
            //transformer.setParameter("param1", "param");

            transformer.transform(new StreamSource(xml),
                                  new StreamResult(out));
        }
        catch (TransformerException ex)
        {
            ex.printStackTrace();
        }
        catch (TransformerFactoryConfigurationError ex)
        {
            ex.printStackTrace();
        }
        return out;
    }

    /*
        public static NodeList getChildList(Element element, String childName)
        {
                try
                {
                    return XPathAPI.selectNodeList(element, childName);
                }
                catch (TransformerException ex)
                {
                    return null;
                }
        }
     */
public  static String getSubTagValue(Node root, String subTagName)
    {
        if (root != null && root.getNodeType() == Node.ELEMENT_NODE )
        {
            return getSubTagValue((Element)root,subTagName);
        }
        else return null;
    }
    public  static String getSubTagValue(Element root, String subTagName)
    {
        String returnString = "";
        NodeList list = root.getElementsByTagName(subTagName);
        for (int loop = 0; loop < list.getLength(); loop++)
        {
            Node node = list.item(loop);
            if (node != null)
            {
                Node child = node.getFirstChild();
                if ( (child != null) && child.getNodeValue() != null)
                {
                    return child.getNodeValue();
                }
            }
        }
        return returnString;

    }
    private static String getSubTagAttribute(Element root, String tagName,
                                             String subTagName,
                                             String attribute)
    {
        String returnString = "";
        NodeList list = root.getElementsByTagName(tagName);
        for (int loop = 0; loop < list.getLength(); loop++)
        {
            Node node = list.item(loop);
            if (node != null)
            {
                NodeList children = node.getChildNodes();
                for (int innerLoop = 0; innerLoop < children.getLength();
                     innerLoop++)
                {
                    Node child = children.item(innerLoop);
                    if ( (child != null) && (child.getNodeName() != null) &&
                        child.getNodeName().equals(subTagName))
                    {
                        if (child instanceof Element)
                        {
                            return ( (Element) child).getAttribute(attribute);
                        }
                    }
                } // end inner loop
            }
        }
        return returnString;
    }

    public static String getSubTagAttribute(Element root, String subTagName,
                                            String attribute)
    {
        String returnString = "";
        NodeList list = root.getElementsByTagName(subTagName);
        for (int loop = 0; loop < list.getLength(); loop++)
        {
            Node node = list.item(loop);
            if (node != null)
            {

                if ( (node != null) && (node.getNodeName() != null) &&
                    node.getNodeName().equals(subTagName))
                {
                    if (node instanceof Element)
                    {
                        return ( (Element) node).getAttribute(attribute);
                    }
                }
            }
        }
        return returnString;
    }

    public static Element getChild(Element element, String nodeName,
                                   String childName, String value)
    {
        try
        {
            NodeList nl = element.getChildNodes(); //getChildList(element, childURI); //XPathAPI.selectNodeList(element, childURI);
            for (int i = 0; i < nl.getLength(); i++)
            {

                Node n = nl.item(i);
                if (n != null && n.getNodeType() == Node.ELEMENT_NODE &&
                    ( (Element) n).getTagName().equals(nodeName))
                {
                    for (Node child = n.getFirstChild(); child != null;
                         child = child.getNextSibling())
                    {
                        //Node node = getChild( (Element) n, childName); //XPathAPI.selectSingleNode(n, childPath);
                        //log.debug(Node.TEXT_NODE);
                        //log.debug(i + "::" + child.getNodeType() + ":" +
                        //                   child.getNodeName());
                        //log.debug(child.getNodeName());
                        if (child.getNodeName().equals(childName) &&
                            getTxtNodeValue(child).equals(value))
                        {
                            return (Element) n;
                        }
                    }
                }
            }
        }

        catch (DOMException ex)
        {
            ex.printStackTrace();
            return null;
        }
        return null;

    }

    public static Element getChild(Element element, String name)
    {
        for (Node child = element.getFirstChild(); child != null;
             child = child.getNextSibling())
        {
            if (child.getNodeType() == Node.ELEMENT_NODE)
            {
                //log.debug("child:::::"+( (Element) child).getTagName() ) ;
                if ( ( (Element) child).getTagName().equals(name))
                {
                    //log.debug(child ) ;
                    return (Element) child;
                }
            }
        }
        return null;
    }

    public static String getTxtNodeValue(Node node)
    {
        String value="";
        for (Node child = node.getFirstChild(); child != null;
             child = child.getNextSibling())
        {
            if (child.getNodeType() == Node.TEXT_NODE )
            {
                value+=child.getNodeValue().trim()  ;
            }
            else if (child.getNodeType() == Node.CDATA_SECTION_NODE )
            {
                value+=child.getTextContent() .trim() ;
            }
        }

//        Node textChild = node.getFirstChild();
//        if (textChild == null)
//        {
//            return "";
//        }
//        return textChild.getNodeValue();
        return value;
    }

    /**
     * get one of the node's leaf node's value
     * @param node the parent Node
     * @param childName the leaf child node,it just has a #TEXT node
     * @return
     */
    public static String getTxtChildValue(Node node, String childName)
    {
        for (Node child = node.getFirstChild(); child != null;
             child = child.getNextSibling())
        {
            if (child.getNodeName().equals(childName))
            {
                return getTxtNodeValue(child);
            }
        }
        return null;
    }
	/*
	  create a new blank Text Element by the path and value
	*/
	public static Node createLeafTextNode(Element rootElement,String path,String value)
	{
		if(path==null)return null;
		String[] nodeName=path.split("\\.");
		Document document=rootElement.getOwnerDocument();
		Element parent=rootElement;
			Element node;
			for(int i=0;i<nodeName.length;i++)
			{
				if( (node = getChild(parent, nodeName[i]))==null)
				{
					node = document.createElement(nodeName[i]);
					parent.appendChild(node);
				}
				parent=node;
			}
			Text text = document.createTextNode(value==null?"":value);
			parent.appendChild(text);
		return parent;
	}
    public static boolean hasChildElements(Node node)
    {
        for (Node child = node.getFirstChild(); child != null;child = child.getNextSibling())
        {
            if (child.getNodeType() == Element.ELEMENT_NODE)
            {
                return true;
            }
        }
        return false;

    }
    public static Object mapElement2Object(Element root,Object object)
    {
        //attributes
        NamedNodeMap attrs=root.getAttributes() ;
        for(int i=0;i<attrs.getLength() ;i++)
        {
            Node attr=attrs.item(i) ;
            String name=attr.getNodeName() ;
            String value=attr.getNodeValue() ;

            String rsGetMethodName = "get" +upperFirstChar(name);
            try
            {
                Method rsGetMethod = object.getClass().getMethod(rsGetMethodName, new Class[]{});

                String setMethodName = "set" + upperFirstChar(name);
                Method setMethod = object.getClass().getMethod(setMethodName,
                    new Class[]{rsGetMethod.getReturnType()});
                Object args[] = new Object[]
                {
                    value
                };
                setMethod.invoke(object, args);
            }
            catch(NoSuchMethodException e)
            {
                //do not exists the method which name matchs the XML attribute's name
            }
            catch (Exception ex)
            {
                ex.printStackTrace() ;
            }
        }
        //child nodes
        NodeList children=root.getChildNodes() ;
        //children.getLength()
        for (Node child = root.getFirstChild(); child != null;child = child.getNextSibling())
        {
            if (child.getNodeType() == Node.ELEMENT_NODE)
            {
                String name = child.getNodeName();
                String value = getTxtNodeValue(child).trim() ;
                String rsGetMethodName = "get" +upperFirstChar(name);
                try
                {
                    Method rsGetMethod = object.getClass().getMethod(rsGetMethodName, new Class[]{});
                    String setMethodName = "set" +upperFirstChar(name);
                    Method setMethod = object.getClass().getMethod(
                            setMethodName,
                            new Class[]{rsGetMethod.getReturnType()});
                    if(hasChildElements(child) )
                    {
                        Object childObject = rsGetMethod.invoke(object,new Object[]{});
                        if (childObject == null)childObject = rsGetMethod.getReturnType().newInstance();
                        Object args[] = new Object[]
                        {
                            mapElement2Object( (Element) child, childObject)
                        };
                        setMethod.invoke(object, args);
                    }
                    else if (!value.equals(""))
                    {
                        Object args[] = new Object[]
                        {
                            value
                        };
                        setMethod.invoke(object, args);
                    }
                }
                catch (NoSuchMethodException e)
                {
                    //do not exists the method which name matchs the XML attribute's name
                }

                catch (Exception ex)
                {
                    ex.printStackTrace();
                }
            }
        }
        return object;
    }
    public static String upperFirstChar(String str)
    {
        char firstChar = Character.toUpperCase(str.charAt(0));
        StringBuffer buffer = new StringBuffer(str);
        buffer.deleteCharAt(0);
        buffer.insert(0, firstChar);
        return buffer.toString();

    }
}
