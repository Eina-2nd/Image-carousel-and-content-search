require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

function TextView()
  import "java.io.File"
  import "android.graphics.Typeface"
  return luajava.bindClass("android.widget.TextView")()
  .setTypeface(Typeface.createFromFile(File(activity.getLuaDir().."/ttf/1.ttf")))
end

activity.getWindow().setStatusBarColor(0x00000000);
activity.setTheme(android.R.style.Theme_DeviceDefault_Light)
activity.setContentView(loadlayout("layout"))
activity.ActionBar.hide()--隐藏标题栏

page.setTouchEnabled(false)

--[[function 水珠动画(view,time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(view,"scaleX",{1.2,.8,1.1,.9,1}).setDuration(time).start()
  ObjectAnimator().ofFloat(view,"scaleY",{1.2,.8,1.1,.9,1}).setDuration(time).start()
end
]]
function 波纹特效v2(颜色)
  import"android.content.res.ColorStateList"
  return activity.Resources.getDrawable(activity.obtainStyledAttributes({android.R.attr.selectableItemBackground--[[Borderless]]}).getResourceId(0,0))
  .setColor(ColorStateList(int[0]
  .class{int{}},int{颜色 or 0x20000000}))
end




a1.foreground=波纹特效v2(0xFF9900FF)
a2.foreground=波纹特效v2(0xFF9900FF)
a3.foreground=波纹特效v2(0xFF9900FF)



a2.setVisibility(View.GONE)
a3.setVisibility(View.GONE)
page.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageScrolled=function(a,b,c)
    if c==0 then
      if a==0 then
        a1.setTextColor(0xFF9900FF)
        a2.setTextColor(0xFF8B8B8B)
        a3.setTextColor(0xFF8B8B8B)
        a1.setVisibility(View.VISIBLE)
        a2.setVisibility(View.GONE)
        a3.setVisibility(View.GONE)
        img1.setColorFilter(0xFF9900FF)
        img2.setColorFilter(0xFF8B8B8B)
        img3.setColorFilter(0xFF8B8B8B)

       elseif a==1 then
        a1.setTextColor(0xFF8B8B8B)
        a2.setTextColor(0xFF9900FF)
        a3.setTextColor(0xFF8B8B8B)
        a2.setVisibility(View.VISIBLE)
        a1.setVisibility(View.GONE)
        a3.setVisibility(View.GONE)
        img2.setColorFilter(0xFF9900FF)
        img1.setColorFilter(0xFF8B8B8B)
        img3.setColorFilter(0xFF8B8B8B)

       elseif a==2 then--热点
        a1.setTextColor(0xFF8B8B8B)
        a2.setTextColor(0xFF8B8B8B)
        a3.setTextColor(0xFF9900FF)
        a3.setVisibility(View.VISIBLE)
        a2.setVisibility(View.GONE)
        a1.setVisibility(View.GONE)
        img3.setColorFilter(0xFF9900FF)
        img2.setColorFilter(0xFF8B8B8B)
        img1.setColorFilter(0xFF8B8B8B)

       elseif a==3 then
        a1.setTextColor(0xFF8B8B8B)
        a2.setTextColor(0xFF8B8B8B)
        a3.setTextColor(0xFF8B8B8B)

        img2.setColorFilter(0xFF8B8B8B)
        img3.setColorFilter(0xFF8B8B8B)
        img1.setColorFilter(0xFF8B8B8B)
      end
    end
  end})

img1.onClick=function()
  page.showPage(0)
  page.setCurrentItem(0, false)
  -- 水珠动画(img1,300)
end
img2.onClick=function()
  page.showPage(1)
  --水珠动画(img2,300)
  page.setCurrentItem(1, false)
end
img3.onClick=function()
  --水珠动画(img3,300)
  page.showPage(2)
  page.setCurrentItem(2, false)
end


wv.loadUrl("/sdcard/AndLua/project/66666/lay/main.html")--加载本地文件

wv.setWebViewClient{
  shouldOverrideUrlLoading=function(view, url)
    -- 只允许http和https协议
    if url:find("^https?://") then
      return false -- 允许WebView自行加载
     else
      print("已拦截外部链接: "..url)
      -- 可以在这里添加Toast提示
      Toast.makeText(activity, "禁止打开外部应用",Toast.LENGTH_SHORT).show()
      return true -- 拦截该请求
    end
  end
}

-- 在WebViewClient中添加拦截
wv.setWebViewClient{
  shouldOverrideUrlLoading=function(view, url)
    -- 检测是否是循环重定向
    if url:find("exit_disabled_page=true") then
      forceExitWebPage()
      return true
    end
    return false
  end
}


-- 添加JavaScript接口
wv.addJavascriptInterface({
  -- 当JavaScript调用Android.openUrl()时会执行这个方法
  openUrl = function(url)
    -- 在WebView中打开链接
    wv. loadUrl(url)
    -- 或者使用系统浏览器打开
    -- activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
  end
}, "Android")
