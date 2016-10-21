/*
 * StackX.java
 *
 * Created on 2007年12月19日, 上午9:32
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.lohool.ola.util;

import java.util.ArrayList;


public class StackX<T> 
{
    private int maxSize;
    private Object[] stackArray;
    private int top;
//--------------------------------------------------------------
    public StackX () 
    {
    	this(5);
    }
    public StackX (int size)      // constructor
    {
        maxSize = size;
        stackArray = new Object[maxSize];
        top = -1;
    }
//--------------------------------------------------------------
    public void push (T j)     // put item on top of stack
    { 
    	if(!isFull())    	stackArray[++top] = j;
    	else
    	{
            maxSize=  (int)(maxSize*1.5)+1;
    		Object[] temp=new Object[maxSize];
    		System.arraycopy(stackArray, 0, temp, 0, stackArray.length);
    		for(Object o:stackArray)o=null;
    		stackArray=temp;
    		stackArray[++top] = j;    		
    	}
    }
//--------------------------------------------------------------
    public T pop ()            // take item from top of stack
    { return (T)stackArray[top--]; }
//--------------------------------------------------------------
    public T peek ()           // peek at top of stack
    { 
    	if(isEmpty()) return null;
    	else return (T)stackArray[top]; 
    }
//--------------------------------------------------------------
    public boolean isEmpty ()    // true if stack is empty
    { return (top == -1); }
//--------------------------------------------------------------
    public boolean isFull ()     // true if stack is full
    { return (top == maxSize-1); }
//--------------------------------------------------------------
    public int size ()           // return size
    { return top+1; }
    public void clear()
    {
    	for(Object o:stackArray)o=null;
    	top=0;
    }
//--------------------------------------------------------------
    public T peekN (int n)     // peek at index n
    { return (T)stackArray[n]; }
//--------------------------------------------------------------
    public void displayStack ()
    {
        System.out.println ("Stack (bottom-->top): ");
        for(int j=0; j< size (); j++)
        {
            System.out.println (peekN (j) );
        }
        System.out.println ("");
    }
//--------------------------------------------------------------
}  // end class StackX