## webpack创建项目详解

### 1. 项目的初始化

> vue init webpack project-name(默认安装2.0版本)
>
> vue init webpack#1.0 project-name(安装1.0版本)

### 2.  webpack的入口文件以及加载的顺序

![webpack入口文件](./img/webpack.png)

### 3. 如何创建多页面项目？

* 思路：

  * 配置对应每个页面的入口，然后每个页面对应的入口文件的加载如上图所示

  * 获取对应的文件的代码如下所示：

    ```javascript
    var _fileInfo = {'dirs': {}}
    function _getSrcFileName(filename){
      var dirName = path.dirname(filename), file = path.basename(filename);
      var fileNoType = path.basename(filename, path.extname(filename));
      var name = '', dir = '';
      while(true){
        if(path.basename(dirName)=='src'|path.basename(dirName)=='.'|path.basename(dirName)=='..'){
          break;
        }
        name = path.basename(dirName) +"\/"+ name;
        dir = path.basename(dirName)+'/'+dir;
        dirName = path.dirname(dirName);
      }
      name = name + fileNoType;
      _fileInfo['dirs'][name] = {'name': name, 'dir': dir, 'filename': file};
      return name;
    };

    exports.getEntry= (globPath) => {
      var entries = {}, basename;
      glob.sync(globPath).forEach(function(entry) {
        basename = path.basename(entry, path.extname(entry));
        var name = _getSrcFileName(entry);
        entries[name] = entry;
      });
      return entries;
    };

    exports.getFullFile = (name) =>{
      var filename = '';
      if(_fileInfo['dirs'][name]!=undefined){
          filename = _fileInfo['dirs'][name]['dir'] + _fileInfo['dirs'][name]['filename']
      }
      return path.resolve(publishDir+'/'+filename);
    };
    ```

  *  在config/index.js中配置如下所示：

    ```javascript
    var build = {
      env: require('./prod.env'),
      assetsRoot: path.resolve(__dirname, '../dist'),
      assetsSubDirectory: 'static',
      assetsPublicPath: '/',
      productionSourceMap: true,
      productionGzip: false,
      productionGzipExtensions: ['js', 'css']
    }
    ```


    var pages = pageUtils.getEntry('src/pages/**/*.html');
    for (var pathname in pages) {
      build[pathname] = pageUtils.getFullFile(pathname);
    }
    module.exports = {
      dev: ...
      build: build // 编译的时候的配置入口文件
    }
    ​```

  *  在webpack.base.conf.js中配置如下所示：

    ```javascript
    var entries = pageUtils.getEntry('./src/pages/**/*.js');
    if(!(process.env.NODE_ENV === 'production')){
      entries['index'] = './src/main.js';
    }
    module.exports = {
      context: path.resolve(__dirname, '../'),
      entry: entries, // 配置js的入口
      ...
      ....
      ...
    }
    ```

  *  在webpack.dev.conf.js中的配置如下所示：

    ```javascript

    const devWebpackConfig = merge(baseWebpackConfig, {
      ...
      devServer: {
        ...
        ...
      plugins: [
        new webpack.DefinePlugin({
          'process.env': require('../config/dev.env')
        }),
         ...
    	// copy custom static assets
       new CopyWebpackPlugin([
         {
           from: path.resolve(__dirname, '../src/assets/'),
           to: config.build.assetsRoot+'/assets/',
           ignore: ['.*']
         }
       ]),
      new CopyWebpackPlugin([
         {
           from: path.resolve(__dirname, '../static/'),
           to: config.build.assetsRoot+'/static/',
           ignore: ['.*']
         }
       ]),
      ]
    })

    module.exports = new Promise((resolve, reject) => {
      portfinder.basePort = process.env.PORT || config.dev.port
      portfinder.getPort((err, port) => {
        if (err) {
          reject(err)
        } else {
          ...
          resolve(devWebpackConfig)
        }
      })
    });

    var pages = pageUtils.getEntry('src/pages/**/*.html');
    if(!process.env.NODE_ENV === 'production'){
      entries['index'] = 'index.html';
    }
    for (var pathname in pages) {
      // 配置生成的html文件，定义路径等
      var conf = {
        filename: pathname+'.html',
        template: pages[pathname], // 模板路径
        inject: true, // js插入
        chunks: [pathname]
      };
      devWebpackConfig.plugins.push(new HtmlWebpackPlugin(conf));
    }
    ```


    ​```

    ​

### 4. 搭建过程中的思路

* 首先需要初始化项目，然后在配置对应的文件的入口
* 其次，在配置项目中的路由等信息