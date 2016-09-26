package com.aegon.comlib;

import java.util.Vector;

// Referenced classes of package com.aegon.comlib:
//            RootClass, UserInfo

public class MenuBean extends RootClass
{
    UserInfo userInfo;
    int iMenuIndex;
    private int iCurrItem;
    private String strMenuHtml;
    private int iFirstLevelCount;

    public MenuBean()
    {
        userInfo = null;
        iMenuIndex = 0;
        iCurrItem = 0;
        strMenuHtml = new String("");
        iFirstLevelCount = 1;
    }

    public MenuBean(UserInfo thisUserInfo)
    {
        userInfo = null;
        iMenuIndex = 0;
        iCurrItem = 0;
        strMenuHtml = new String("");
        iFirstLevelCount = 1;
        if(thisUserInfo == null)
        {
            setLastError(getClass().getName() + ".MenuBean()", "The input parameter UserInfo is null");
        } else
        {
            setUserInfo(thisUserInfo);
            setDebugFileName(thisUserInfo.getDebugFileName());
            setDebug(thisUserInfo.getDebug());
            setSessionId(thisUserInfo.getSessionId());
        }
    }

    public UserInfo getUserInfo()
    {
        return userInfo;
    }

    public void setUserInfo(UserInfo thisUserInfo)
    {
        if(thisUserInfo != null)
            userInfo = thisUserInfo;
    }

    public String getMenuHtml(String strClassName, String strOnMouseOver, String strOnMouseOut, String strOnClick)
    {
        iCurrItem = 0;
        String strCurrMenu = new String("");
        boolean bShouldEnd = false;
//        writeDebugLog(3, getClass().getName() + ".getMenuHtml()", "enter");
//        writeDebugLog(3, getClass().getName() + ".getMenuHtml()", "Size of UserFuncTree is '" + String.valueOf(getUserInfo().getSizeOfUserFuncTree()) + "'");
        strMenuHtml = "";
        if(getUserInfo().getSizeOfUserFuncTree() == 0)
            writeDebugLog(1, getClass().getName() + ".getMenuHtml()", "Size of UserFuncTree is zero, can't process.");
        else
            for(; iCurrItem < getUserInfo().getSizeOfUserFuncTree(); iCurrItem++)
            {
//                writeDebugLog(3, getClass().getName() + ".getMenuHtml()", "The '" + String.valueOf(iCurrItem) + "'-th fucn_id is '" + getUserInfo().getFunctionIdUp(iCurrItem) + "'");
                if(getUserInfo().getFunctionIdUp(iCurrItem).equals(""))
                {
                    processFunction(strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
                } else
                {
                    if(!strCurrMenu.equals(getUserInfo().getFunctionIdUp(iCurrItem)))
                    {
                        writeOneMenu(getUserInfo().getFunctionIdUp(iCurrItem), getUserInfo().getFuncNameUp(iCurrItem), strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
                        strCurrMenu = getUserInfo().getFunctionIdUp(iCurrItem);
                    }
                    if(getUserInfo().getProperty(iCurrItem).equals("M"))
                        processSubMenu(strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
                    else
                        processFunction(strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
                    if(iCurrItem <= getUserInfo().getSizeOfUserFuncTree() - 2)
                    {
                        if(!strCurrMenu.equals(getUserInfo().getFunctionIdUp(iCurrItem + 1)))
                            strMenuHtml += "</DIV>\r\n";
                    } else
                    {
                        strMenuHtml += "</DIV>\r\n";
                    }
                }
            }

//        writeDebugLog(3, getClass().getName() + ".getMenuHtml()", "Exit");
        return strMenuHtml;
    }

    private void processFunction(String strClassName, String strOnMouseOver, String strOnMouseOut, String strOnClick)
    {
//        writeDebugLog(3, getClass().getName() + ".processFunction()", "process fucn_id = '" + getUserInfo().getFunctionIdDown(iCurrItem).trim() + "' func_name = '" + getUserInfo().getFuncName(iCurrItem).trim() + "'");
        strMenuHtml = strMenuHtml + "<DIV id=\"" + getUserInfo().getFunctionIdDown(iCurrItem).trim() + "\" " + " href=\"" + getUserInfo().getUrl(iCurrItem).trim() + "\"" + " target=\"" + getUserInfo().getTargetWindow(iCurrItem).trim() + "\"" + " onClick=\"mOnClick('" + getUserInfo().getFunctionIdDown(iCurrItem).trim() + "','" + getUserInfo().getUrl(iCurrItem).trim() + "','" + getUserInfo().getTargetWindow(iCurrItem).trim() + "');\"" + " style=\"cursor:hand;width:117;text-decoration: none;background-image:url(" + getUserInfo().getImageFileOff(iCurrItem).trim() + ");\"" + " onMouseOver=\"" + strOnMouseOver + "\" onMouseOut=\"" + strOnMouseOut + "\">" + "<FONT size=2 style=\"position: relative;top:2;left:18;color:white; \">" + getUserInfo().getFuncName(iCurrItem).trim() + "</FONT></DIV>";
    }

    private void processSubMenu(String strClassName, String strOnMouseOver, String strOnMouseOut, String strOnClick)
    {
        Vector vtFunc = new Vector(1, 5);
        int i = 0;
        String strMenuItem = getUserInfo().getFunctionIdDown(iCurrItem);
//        writeDebugLog(3, getClass().getName() + ".processSubMenu()", "Enter, the current item is '" + String.valueOf(iCurrItem) + "' func_id = '" + strMenuItem + "' next func_id_up is '" + getUserInfo().getFunctionIdUp(iCurrItem + 1) + "'");
        writeOneMenu(strMenuItem, getUserInfo().getFuncName(iCurrItem), strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
        while(strMenuItem.equals(getUserInfo().getFunctionIdUp(iCurrItem + 1))) 
        {
            iCurrItem++;
//            writeDebugLog(3, getClass().getName() + ".processSubMenu()", "After incress the current item is '" + String.valueOf(iCurrItem) + "', the property is '" + getUserInfo().getProperty(iCurrItem) + "'");
            if(getUserInfo().getProperty(iCurrItem).equals("M"))
                processSubMenu(strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
            else
                processFunction(strClassName, strOnMouseOver, strOnMouseOut, strOnClick);
            if(iCurrItem >= getUserInfo().getSizeOfUserFuncTree() - 1)
                break;
        }
        strMenuHtml += "</DIV>\r\n";
    }

    private void writeOneMenu(String strFuncId, String strFuncName, String strClassName, String strOnMouseOver, String strOnMouseOut, String strOnClick)
    {
//        writeDebugLog(3, getClass().getName() + ".writeOneMenu()", "Enter, the current item is '" + String.valueOf(iCurrItem) + "', the func_id is '" + strFuncId + "', the func_name is '" + strFuncName + "'");
        strMenuHtml = strMenuHtml + "<SPAN id=\"" + strFuncId + "\" class=\"" + strClassName + "\" " + " onClick=\"" + strOnClick + "\" style=\"margin-top:0px;cursor:hand;width:117;text-decoration: none;background-image:url(";
        if(getUserInfo().getProperty(iCurrItem) == "P")
            strMenuHtml += getUserInfo().getImageFileOff(iCurrItem);
        else
            strMenuHtml += getUserInfo().getImageFileOffUp(iCurrItem);
        strMenuHtml += ");\"><FONT size=2 style=\"position: relative;top:2;left:18;color:white; \">" + strFuncName + "</FONT></SPAN>\r\n";
        strMenuHtml = strMenuHtml + "<DIV id=\"" + strFuncId + "\" style=\"display:none;margin-left : 5px;margin-top:0px;\">\r\n";
    }

    public String getHvMenuHtml(int iHeight, int iWidth)
    {
        String strCurrMenu = new String("");
        boolean bShouldEnd = false;
        String strMenuPrefix = new String("Menu");
        int iSecondLevelCount = 0;
        boolean bLevelBreak = true;
        String strMenuVariable = new String("");
//        writeDebugLog(3, getClass().getName() + ".getHvMenuHtml()", "enter");
//        writeDebugLog(3, getClass().getName() + ".getHvMenuHtml()", "Size of UserFuncTree is '" + String.valueOf(getUserInfo().getSizeOfUserFuncTree()) + "'");
        strMenuHtml = "";
        iCurrItem = 0;
        iFirstLevelCount = 0;
        if(getUserInfo().getSizeOfUserFuncTree() == 0)
            writeDebugLog(1, getClass().getName() + ".getHvMenuHtml()", "Size of UserFuncTree is zero, can't process.");
        else
            for(; iCurrItem < getUserInfo().getSizeOfUserFuncTree(); iCurrItem++)
            {
//                writeDebugLog(3, getClass().getName() + ".getHvMenuHtml()", "The '" + String.valueOf(iCurrItem) + "'-th fucn_id is '" + getUserInfo().getFunctionIdUp(iCurrItem) + "'");
                if(getUserInfo().getFunctionIdUp(iCurrItem).equals(""))
                {
                    strMenuVariable = strMenuPrefix + String.valueOf(++iFirstLevelCount);
                    processHvFunction(iHeight, iWidth, strMenuVariable);
                } else
                {
                    if(!strCurrMenu.equals(getUserInfo().getFunctionIdUp(iCurrItem)))
                    {
                        strMenuVariable = strMenuPrefix + String.valueOf(++iFirstLevelCount);
                        writeHvOneMenu(getUserInfo().getFunctionIdUp(iCurrItem), getUserInfo().getFuncNameUp(iCurrItem), iHeight, iWidth, strMenuVariable);
                        strCurrMenu = getUserInfo().getFunctionIdUp(iCurrItem);
                        iSecondLevelCount = 1;
                    }
                    strMenuVariable = strMenuPrefix + String.valueOf(iFirstLevelCount) + "_" + String.valueOf(iSecondLevelCount++);
                    if(getUserInfo().getProperty(iCurrItem).equals("M"))
                        processHvSubMenu(iHeight, iWidth, strMenuVariable);
                    else
                        processHvFunction(iHeight, iWidth, strMenuVariable);
                }
            }

//        writeDebugLog(3, getClass().getName() + ".getHvMenuHtml()", "Exit");
        return strMenuHtml;
    }

    private void processHvFunction(int iHeight, int iWidth, String strMenuVariable)
    {
//        writeDebugLog(3, getClass().getName() + ".processHvFunction()", "process fucn_id = '" + getUserInfo().getFunctionIdDown(iCurrItem).trim() + "' func_name = '" + getUserInfo().getFuncName(iCurrItem).trim() + "'");
        strMenuHtml = strMenuHtml + " " + strMenuVariable + " = new Array(\"" + getUserInfo().getFuncName(iCurrItem).trim() + "\",\"" + getUserInfo().getUrl(iCurrItem).trim() + "\",\"\",0," + String.valueOf(iHeight) + "," + String.valueOf(iWidth) + ",\""+ getUserInfo().getHitCountUrl(iCurrItem).trim()+"\",\""+getUserInfo().getTargetWindow(iCurrItem).trim()+"\" );\r\n";
    }

    private void processHvSubMenu(int iHeight, int iWidth, String strMenuPrefix)
    {
        String strMenuItem = getUserInfo().getFunctionIdDown(iCurrItem);
        int iCurrLevel = 1;
        int iNextLevel = 1;
//        writeDebugLog(3, getClass().getName() + ".processHvSubMenu()", "Enter, the current item is '" + String.valueOf(iCurrItem) + "' func_id = '" + strMenuItem + "' next func_id_up is '" + getUserInfo().getFunctionIdUp(iCurrItem + 1) + "'");
        writeHvOneMenu(strMenuItem, getUserInfo().getFuncName(iCurrItem), iHeight, iWidth, strMenuPrefix);
        while(strMenuItem.equals(getUserInfo().getFunctionIdUp(iCurrItem + 1))) 
        {
            iCurrItem++;
//            writeDebugLog(3, getClass().getName() + ".processHvSubMenu()", "After incressd, the current item is '" + String.valueOf(iCurrItem) + "', the property is '" + getUserInfo().getProperty(iCurrItem) + "'");
            String strMenuVariable = new String(strMenuPrefix + "_" + String.valueOf(iCurrLevel++));
            if(getUserInfo().getProperty(iCurrItem).equals("M"))
                processHvSubMenu(iHeight, iWidth, strMenuVariable);
            else
                processHvFunction(iHeight, iWidth, strMenuVariable);
            if(iCurrItem >= getUserInfo().getSizeOfUserFuncTree() - 1)
                break;
        }
    }

    private void writeHvOneMenu(String strFuncId, String strFuncName, int iHeight, int iWidth, String strMenuVariable)
    {
//        writeDebugLog(3, getClass().getName() + ".writeHvOneMenu()", "Enter, the current item is '" + String.valueOf(iCurrItem) + "', the func_id is '" + strFuncId + "', the func_name is '" + strFuncName + "'");
        int iSubItemCount = getSubItemCount(strFuncId);
        strMenuHtml += " " + strMenuVariable + " = new Array(\"" + strFuncName + "\",\"\",\"\"," + String.valueOf(iSubItemCount) + "," + String.valueOf(iHeight) + "," + String.valueOf(iWidth) + ");\r\n";
    }

    private int getSubItemCount(String strCurrFuncId)
    {
        int i = 0;
        int iSubItemCount = 0;
        if(iCurrItem < getUserInfo().getSizeOfUserFuncTree() && strCurrFuncId != null && !strCurrFuncId.equals(""))
            for(i = iCurrItem; i < getUserInfo().getSizeOfUserFuncTree(); i++)
                if(strCurrFuncId.equals(getUserInfo().getFunctionIdUp(i)))
                    iSubItemCount++;

        return iSubItemCount;
    }

    public String getNoOffFirstLineMenus()
    {
        String strTmp = getHvMenuHtml(0, 0);
        return String.valueOf(iFirstLevelCount);
    }

}