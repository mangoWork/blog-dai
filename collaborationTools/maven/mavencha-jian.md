## 该部分主要介绍Maven不同的插件

### 1. 打包插件

| 打包插件 | 功能 |
| :---: | :---: |
| maven-jar-plugin | maven默认的打包工具，如果需要打包依赖包，需要配合maven-dependency-plugin使用 |
| maven-shade-plugin | 用来打可执行包， |
| maven-assembly-plugin | 支持定制化打包 |

####1.1 maven-assembly-plugin打包：
    ```xml
    <plugin>
      <artifactId>maven-assembly-plugin</artifactId>
      <configuration>
        <archive>
          <manifest>
            <mainClass>cn.com.bonc.category.Handle</mainClass>
          </manifest>
        </archive>
        <descriptorRefs>
          <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
      </configuration>
    </plugin>
    ```
    
  