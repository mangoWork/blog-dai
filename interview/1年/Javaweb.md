## spring 知识点

### 1. 什么是Spring框架？Spring框架有哪些模块？

* spring框架是一个为Java应用程序的开发提供了综合、广泛的基础性支持的Java平台。

* Spring框架包含的模块如下图所示：

  ![](../img/spring/spring_moudle.png)

### 2. 使用Spring框架的优缺点？

1. 独立于各种应用服务器，基于Spring框架的应用，可以真正实现Write Once,Run Anywhere的承诺
2. Spring的DI机制降低了业务对象替换的复杂性，提高了组件之间的解耦
3. Spring的AOP支持允许将一些通用任务如安全、事务、日志等进行集中式管理，从而提供了更好的复用
4. Spring的ORM和DAO提供了与第三方持久层框架的良好整合，并简化了底层的数据库访问
5. Spring并不强制应用完全依赖于Spring，开发者可自由选用Spring框架的部分或全部

### 3. 什么是控制反转(IOC)?什么是依赖注入？

* 控制反转：创建对象实例的控制权从代码控制剥离到IOC容器控制，实际就是你在xml文件控制。
* 依赖注入：创建对象实例时，为这个对象注入属性值或其它对象实例。 

### 4.  BeanFactory和ApplicationContext有什么区别？

* BeanFactory 可以理解为含有bean集合的工厂类。BeanFactory 包含了种bean的定义，以便在接收到客户端请求时将对应的bean实例化。
* application context如同bean factory一样具有bean定义、bean关联关系的设置，根据请求分发bean的功能。但application context在此基础上还提供了其他的功能。
  1. 提供了支持国际化的文本消息
  2. 统一的资源文件读取方式
  3. 已在监听器中注册的bean的事件

### 5. Spring的几种配置方式，以及如何使用？

1. 基于XML的配置
2. 基于注解的配置
3. 基于Java的配置

* 基于xml的配置
  * ​

### 6. Spring Bean的生命周期？

### 7. Spring Bean的作用域之间有什么区别？

### 8. 什么是Spring inner beans？

### 9. Spring框架中地单例Beans是线程安全的吗？

### 10. Spring Bean的自动装配？

### 11. 几种自动装配模式的区别？

### 12. 如何开启基于注解的自动装配？

### 13. 构造注入和设值注入有什么区别？

### 14. Spring框架中使用到了哪些设计模式？

* 代理模式：在AOP中被用得比较多
* 单例模式：在spring配置文件中定义的Bean默认为单例模式
* 工厂模式：BeanFactory用来创建对象的实例

### 15. Spring是如何管理事务的？

