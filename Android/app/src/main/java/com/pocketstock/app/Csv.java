package com.pocketstock.app;
import java.util.*;
public final class Csv {
 public static List<List<String>> parse(String text,char delimiter){
  if(text.startsWith("\uFEFF"))text=text.substring(1);
  List<List<String>> out=new ArrayList<>();List<String> row=new ArrayList<>();StringBuilder cell=new StringBuilder();boolean quoted=false;
  for(int i=0;i<text.length();i++){char c=text.charAt(i);
   if(c=='"'){if(quoted&&i+1<text.length()&&text.charAt(i+1)=='"'){cell.append('"');i++;}else if(quoted||cell.length()==0)quoted=!quoted;else cell.append(c);}
   else if(!quoted&&c==delimiter){row.add(cell.toString());cell.setLength(0);}
   else if(!quoted&&(c=='\n'||c=='\r')){if(c=='\r'&&i+1<text.length()&&text.charAt(i+1)=='\n')i++;row.add(cell.toString());if(nonblank(row))out.add(row);row=new ArrayList<>();cell.setLength(0);}
   else cell.append(c);
  }
  if(quoted)throw new IllegalArgumentException("Unclosed quoted field");row.add(cell.toString());if(nonblank(row))out.add(row);return out;
 }
 static boolean nonblank(List<String> r){for(String s:r)if(!s.trim().isEmpty())return true;return false;}
 public static List<List<String>> detect(String text){List<List<String>> best=null;int score=-1;for(char d:new char[]{',',';','\t'}){try{List<List<String>> r=parse(text,d);if(r.isEmpty())continue;int width=r.get(0).size(),same=0;for(int i=1;i<Math.min(r.size(),21);i++)if(r.get(i).size()==width)same++;int s=width>1?same*100+width:0;if(s>score){score=s;best=r;}}catch(IllegalArgumentException e){}}if(best==null)throw new IllegalArgumentException("Empty or invalid CSV");return best;}
 public static String line(List<String> r){List<String> q=new ArrayList<>();for(String s:r)q.add("\""+s.replace("\"","\"\"")+"\"");return String.join(",",q)+"\r\n";}
}
