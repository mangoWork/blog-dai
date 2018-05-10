## Mybatis知识点总结

### 0. 介绍Mybatis是什么？

* Mybatis是什么？

  * mybatis是一个优秀的持久层框架，他对jdbc操作数据库的过程进行了封装，使开发着只用关注sql本身，不用去关注例如注册驱动，加载链接，得到statement，处理结果集等复杂的过程。 
    mybatis通过xml或者注解的方式，将要执行的各种sql语句配置起来，并通过Java对象和statement中的sql语句映射生成最终的sql语句，最后由mybatis框架执行sql语句，并将结果映射成Java对象返回。 

* 工作原理？

  * mybatis通过配置文件创建sqlsessionFactory，sqlsessionFactory根据配置文件，配置文件来源于两个方面:一个是xml，一个是Java中的注解，获取sqlSession。SQLSession包含了执行sql语句的所有方法，可以通过SQLSession直接运行映射的sql语句，完成对数据的增删改查和事物的提交工作，用完之后关闭SQLSession。 

* 工作流程？

  *  mapper接口：

    接口的全限定名是xml文件中namespace的值。

    - 接口中的方法名是xml文件中mappedstatement的id值。
    - 接口中方法的参数就是传递给sql的参数
    - mapper接口是没有实现类的，当调用一个方法时，接口的全类名定位一个配置文件，接口的方法名定位这个配置文件中的一个mapperStatment，所以说mapper的方法名是不能重载的，因为mapperStatment的保存和寻找策略。
    - mapper接口的工作原理是，mybatis会使用jdk动态代理方式为mapper接口创建proxy对象，代理对象会拦截接口中的方法，转而执行mapperStatment所代表的sql语句，然后将执行的结果封装返回。

*  Mybatis解决的问题？

  * 1.使用数据库连接池管理链接，避免了频繁创建了、关闭链接，浪费资源，影响性能的问题。
  * 2.用xml管理sql语句，让Java代码和sql语句分离，使得代码更易维护。
  * 3.解决了sql语句参数不定的问题。xml中可以通过where条件决定sql语句的条件参数。mybatis将Java对象映射到sql语句，通过statement的parameterType定义输入参数的类型。
  * 4.mybatis自动将结果集封装成Java对象， 通过statement的resultType定义输出的类型。避免了因sql变化，对结果集处理麻烦的问题。

### 1. #{}和${}的区别是什么？

*  其中${}是properties文件中的占位符，它可以用于标签属性值和sql内部，属于静态文本替换，比如{driver}就会被替换成com.mysql.jdbc.Driver。#{}是sql的占位符，Mybatis会将sql中的#{}替换为？号，在sql执行的时候会使用PreparedStatement的参数设置方法，按序给sql的？号占位符设置参数值，比如ps.setInt(0, parameterValue)，#{item.name}的取值的方式是使用反射从参数对象中获取item对象的name属性值，相当于param.getItem().getName()。

### 2. xml映射文件中，除了常见的select|insert|update|delete标签之外，还有哪些标签？

* selectKey标签、resultMap标签、include标签、parametrMap标签、sql标签、include标签，加上9个动态标签：choose、when、otherwise、trim、where、set、foreach、if、bind。其中sql标签为sql片段标签。通过include标签引入sql片段。

### 3. 最佳实践中，通常一个xml映射文件，都会写一个Dao接口与之对应，请问，这个Dao的原理是什么？Dao接口里的方法，参数不同时，方法能够重载吗？

*  Dao接口也就是Mapper接口，接口的权限定名就是映射文件中的namespace的值，接口的方法就是映射文件中的MappedStatment（一个对象，对应Mapper配置文件中的一个select/update/insert/delete节点，主要描述SQL语句的）中的对应的id，接口方法的参数就是传递给sql的参数。Mapper接口没有实现，当调用方法时，接口全限定名+方法名拼接字符串作为key值，可以找到唯一一个MappedStatement。
* Dao接口方法中，是不能够重载的，因为是全限定名+方法名的保存和寻找策略。
*  Dao接口的工作原理是JDK动态代理，Mybatis运行时会使用JDK动态代理为Dao接口生成proxy对象，代理对象proxy会拦截接口方法，转而执行MappedStatement所代表的sql，然后将sql执行结果返回。

### 4. Mybatis是如何进行分页的？分页插件的原理是什么？

*  Mybatis是使用RowBounds对象进行分页，它针对ResultSet结果集执行的内存分页，而非物理分页，可以在sql内直接书写屋里分页参数来完成物理分页功能，也可以使用分页插件来完成物理分页。
*  分页插件的基本原理是使用Mybatis提供的插件接口，实现自定义插件，在插件的拦截方法内拦截待执行的sql，然后重写sql，添加对应的物理分页语句和物理分页参数。如下所示：
  *  select * from student,拦截sql语句后重写为seletc t.* from (select * from student) t limit 0, 10

### 5.  简述Mybatis的插件的运行的原理，如何编写一个插件？

* Mybatis仅可以编写针对ParameterHandler、ResultSetHandler、StatementHandler、Executor这4种接口的插件，Mybatis使用JDK的动态代理，为需要拦截的接口生成代理对象以实现接口方法拦截功能，每当执行这4种接口对象的方法时，就会进入拦截方法，具体就是InvocationHandler的invoke()方法，当然，只会拦截那些你指定需要拦截的方法。
* 实现Mybatis的Interceptor接口并复写intercept()方法，然后在给插件编写注解，指定要拦截哪一个接口的哪些方法即可，记住，别忘了在配置文件中配置你编写的插件。

### 6. Mybatis执行批量插入，能返回数据库主键列表吗？

* 可以，

### 7. Mybatis动态sql是做什么的？都有哪些动态sql？简述一下动态sql执行的原理？

*   Mybatis动态sql可以让我们在xml映射文件中以标签的形式动态编写sql，完成逻辑的判断和动态的拼接sql功能。
* Mybatis提供了9中动态sql标签，分别是：choose、when、otherwise、if、where、trim、bind、set、foreach。
* 其执行的原理为使用OGNL从sql参数对象中计算表达式的值，根据表达式的值动态拼接sql，以此完成动态sql的功能。

### 8.  Mybatis是如何将sql执行结果封装为目标对象返回的？都有哪些映射形式？

* 使用resultMap标签，逐一定义列名和对象属性之间的映射关系。第二种是使用sql列的别名功能，将列名书写为对象属性名，比如将``T_name as name``,对象属性名一般是name，小写，但是列名不区分大小写，Mybatis会忽略列名的大小写。找到与之对应的属性名
* 有了列名与属性名之间的映射关系之后，Mybatis通过反射创建对象，同时使用反射给对象的属性逐一赋值并返回，那些找不到映射关系的属性，将无法完成赋值。

### 9. Mybatis能执行一对一、一对多的关联查询吗？都有哪些实现方式，以及他们之间的区别？

*  可以实现，不仅可以实现一对一、一对多还能执行多对一、多对多的查询。

* 一种是单独发送一个sql去查询关联对象，赋给主对象，然后返回主对象。另一种是使用嵌套查询，嵌套查询的含义为使用join查询，一部分列是A对象的属性值，另外一部分列是关联对象B的属性值，好处是只发一个sql查询，就可以把主对象和其关联对象查出来。

* join查询出来100条记录，如何确定主对象是5个，而不是100个？其去重复的原理是<resultMap>标签内的<id>子标签，指定了唯一确定一条记录的id列，Mybatis根据<id>列值来完成100条记录的去重复功能，<id>可以有多个，代表了联合主键的语意。

  同样主对象的关联对象，也是根据这个原理去重复的，尽管一般情况下，只有主对象会有重复记录，关联对象一般不会重复。

### 10. Mybatis是否支持延迟加载？如果支持，它的实现原理是什么？

* Mybatis仅支持association关联对象和collection关联集合对象的延迟加载，association指的就是一对一，collection指的就是一对多查询。在Mybatis配置文件中，可以配置是否启用延迟加载lazyLoadingEnabled=true|false。
*  它的原理是，使用CGLIB创建目标对象的代理对象，当调用目标方法时，进入拦截器方法，比如调用a.getB().getName()，拦截器invoke()方法发现a.getB()是null值，那么就会单独发送事先保存好的查询关联B对象的sql，把B查询上来，然后调用a.setB(b)，于是a的对象b属性就有值了，接着完成a.getB().getName()方法的调用。这就是延迟加载的基本原理

### 11. Mybatis的xml映射文件中，不同的xml映射文件，id是否可以重复？

* 不同的Xml映射文件，如果配置了namespace，那么id可以重复；如果没有配置namespace，那么id不能重复；毕竟namespace不是必须的，只是最佳实践而已。

### 12. Mybatis如何执行批处理？ 

* 使用BatchExecutor完成批处理。

### 13 Mybatis都有哪些Executor执行器？它们之间的区别是什么？

- Mybatis有三种基本的Executor执行器，SimpleExecutor、ReuseExecutor、BatchExecutor
- **SimpleExecutor：**每执行一次update或select，就开启一个Statement对象，用完立刻关闭Statement对象。
- ReuseExecutor：执行update或select，以sql作为key查找Statement对象，存在就使用，不存在就创建，用完后，不关闭Statement对象，而是放置于Map<String, Statement>内，供下一次使用。简言之，就是重复使用Statement对象。
- BatchExecutor：执行update（没有select，JDBC批处理不支持select），将所有sql都添加到批处理中（addBatch()），等待统一执行（executeBatch()），它缓存了多个Statement对象，每个Statement对象都是addBatch()完毕后，等待逐一执行executeBatch()批处理。与JDBC批处理相同。

### 14. Mybatis如何指定执行使用哪一种excutor执行器？

* 在Mybatis配置文件中，可以指定默认的ExecutorType执行器类型，也可以手动给DefaultSqlSessionFactory的创建SqlSession的方法传递ExecutorType类型参数。

### 15. Mybatis是否可以映射Enum枚举类？

* Mybatis可以映射枚举类，不单可以映射枚举类，Mybatis可以映射任何对象到表的一列上。映射方式为自定义一个TypeHandler，实现TypeHandler的setParameter()和getResult()接口方法。

### 16.  Mybatis映射文件中，如果A标签includeB标签的内容，请问，B标签能否定义在A标签的后面，还是说必须定义在A标签的前面？

* 虽然Mybatis解析Xml映射文件是按照顺序解析的，但是，被引用的B标签依然可以定义在任何地方，Mybatis都可以正确识别。
* 原理是，Mybatis解析A标签，发现A标签引用了B标签，但是B标签尚未解析到，尚不存在，此时，Mybatis会将A标签标记为未解析状态，然后继续解析余下的标签，包含B标签，待所有标签解析完毕，Mybatis会重新解析那些被标记为未解析的标签，此时再解析A标签时，B标签已经存在，A标签也就可以正常解析完成了。

### 17. 简述Mybatis的xml映射文件和Mybatis内部数据结构之间的映射关系？

* Mybatis将所有Xml配置信息都封装到All-In-One重量级对象Configuration内部。在Xml映射文件中，<parameterMap>标签会被解析为ParameterMap对象，其每个子元素会被解析为ParameterMapping对象。<resultMap>标签会被解析为ResultMap对象，其每个子元素会被解析为ResultMapping对象。每一个<select>、<insert>、<update>、<delete>标签均会被解析为MappedStatement对象，标签内的sql会被解析为BoundSql对象。

### 18. 为什么说Mybatis是半自动化ORM映射工具？它与全自动化工具的区别在哪里？

* Hibernate属于全自动ORM映射工具，使用Hibernate查询关联对象或者关联集合对象时，可以根据对象关系模型直接获取，所以它是全自动的。而Mybatis在查询关联对象或关联集合对象时，需要手动编写sql来完成，所以，称之为半自动ORM映射工具。

### 19.  Mybatis插入单条数据并且返回自增主键？批量插入数据怎样返回主键列表？
*  1. 在insert标签中使用useGeneratedKeys以及keyProperty，代码如下所示：
   ```xml
   <insert id="insertStudent" parameterType="com.soecode.lyf.entity.Student" useGeneratedKeys="true" keyProperty="student.id">
    </insert>
   ```
    2. 使用selectKey标签，以及使用LAST_INSERT_ID()函数，如下代码所示：
    ```xml
    <insert id="insertStudent1" parameterType="com.soecode.lyf.entity.Student">
          <selectKey keyProperty="student.id" resultType="int">
             select LAST_INSERT_ID()
          </selectKey>
          insert into student (name, age) VALUE(#{student.name}, #{student.age})
    </insert>
    ```

* 批量插入数据返回主键列表，跟单条数据插入没有区别，注意：如果Mybatis版本为3.3.0则不行，需要将Mybatis版本升级到Mybatis3.3.1及其以上,Dao中不能使用@Param注解,Mapper.xml中使用list变量接收参数


### 20. 简单的说一下MyBatis的一级缓存和二级缓存？

* Mybatis首先去缓存中查询结果集，如果没有则查询数据库，如果有则从缓存取出返回结果集就不走数据库。Mybatis内部存储缓存使用一个HashMap，key为hashCode+sqlId+Sql语句。value为从查询出来映射生成的java对象
* Mybatis的二级缓存即查询缓存，它的作用域是一个mapper的namespace，即在同一个namespace中查询sql可以从缓存中获取数据。二级缓存是可以跨SqlSession的。

### 21. 使用MyBatis的mapper接口调用时有哪些要求？

* Mapper接口方法名和mapper.xml中定义的每个sql的id相同 
* Mapper接口方法的输入参数类型和mapper.xml中定义的每个sql 的parameterType的类型相同 
* Mapper接口方法的输出参数类型和mapper.xml中定义的每个sql的resultType的类型相同 
* Mapper.xml文件中的namespace即是mapper接口的类路径。

### 22. MyBatis编程步骤是什么样的？

1. 创建SqlSessionFactory 
2. 通过SqlSessionFactory创建SqlSession 
3. 通过sqlsession执行数据库操作 
4. 调用session.commit()提交事务 
5. 调用session.close()关闭会话

### 23. Mapper编写有哪几种方式？

1. 接口实现类继承SqlSessionDaoSupport
   1. 在sqlMapConfig.xml中配置mapper.xml的位置

      ```xml
      <mappers>
          <mapper resource="mapper.xml文件的地址" />
          <mapper resource="mapper.xml文件的地址" />
      </mappers>
      ```

   2.  定义mapper接口

   3.  接口实现类继承SqlSessionDaoSupport，实现方法可以使用this.getSqlSession()进行数据增删改查

   4.  spring的配置

      ```xml
      <bean id=" " class="mapper接口的实现">
          <property name="sqlSessionFactory" ref="sqlSessionFactory"></property>
      </bean>
      ```

2.  org.mybatis.spring.mapper.MapperFactoryBean

   1. 在sqlMapConfig.xml中配置mapper.xml的位置,如果mapper.xml和mappre接口的名称相同且在同一个目录，这里可以不用配置

      ```xml
      <mappers>
          <mapper resource="mapper.xml文件的地址" />
          <mapper resource="mapper.xml文件的地址" />
      </mappers>
      ```

   2.  定义mapper接口(mapper.xml中的namespace为mapper接口的地址、mapper接口中的方法名和mapper.xml中的定义的statement的id保持一致)

   3.  Spring中定义

      ```xml
      <bean id="" class="org.mybatis.spring.mapper.MapperFactoryBean">
          <property name="mapperInterface"   value="mapper接口地址" /> 
          <property name="sqlSessionFactory" ref="sqlSessionFactory" /> 
      </bean>
      ```

3.  使用mapper扫描器

   1. mapper.xml文件编写

      * mapper.xml中的namespace为mapper接口的地址
      * mapper接口中的方法名和mapper.xml中的定义的statement的id保持一致
      * 如果将mapper.xml和mapper接口的名称保持一致则不用在sqlMapConfig.xml中进行配置

   2. 定义mapper接口

   3.  配置mapper扫描器

      ```xml
      <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
      		<property name="dataSource" ref="dataSource" />
      		<!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
      		<property name="configLocation" value="classpath:mybatis-config.xml" />
      		<!-- 扫描entity包 使用别名 -->
      		<property name="typeAliasesPackage" value="com.soecode.lyf.entity" />
      		<!-- 扫描sql配置文件:mapper需要的xml文件 -->
      		<property name="mapperLocations" value="classpath:mapper/*.xml" />
      	</bean>
      	<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
      		<property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
      		<property name="basePackage" value="com.soecode.lyf.dao" />
      	</bean>
      ```

### 24. resultType 和resultMap 的区别。

* 当使用resultType做SQL语句返回结果类型处理时，对于SQL语句查询出的字段在相应的pojo中必须有和它相同的字段对应
* 当使用resultMap做SQL语句返回结果类型处理时，通常需要在mapper.xml中定义resultMap进行pojo和相应表字段的对应。