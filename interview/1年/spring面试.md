## 一、 Spring概述

1.  什么是Spring？

   > Spring是一个轻量级的IOC以及AOP容器框架，可以对JavaBean的生命周期进行管理。

2.  使用Spring框架有什么好处？

   1. 轻量：Spring是轻量的，基本版本大约2MB。
   2. 控制反转(IOC)：Spring通过控制反转实现了松散耦合。
   3. 面向切面编程(AOP):Spring支持面向切面编程，并且把应用业务逻辑和系统服务分开。
   4. 容器：Spring包含并管理应用中对象生命周期和配置。
   5. 事务处理：Spring事务处理提供了一个持续的事务管理接口，可以扩展到上至本地事务下至全局事务。
   6. 异常处理：Spring提供方便的API把具体技术相关的异常转化为一致的unchecked异常。

3. Spring由哪些模块组成的？

   ![](../img/spring/spring_moudle.png)

4.  核心容器(应用上下文)模块

   > 这是基本的Spring模块，提供Spring框架的基础功能，BeanFactory是任何以Spring为基础的应用的核心。Spring框架建立在此基础上，它使Spring成为一个容器。

5. BeanFactory—(实现举例)

   > Bean 工厂是工厂模式的一个实现，提供了控制反转功能，用来把应用的配置和依赖从正真的应用代码中分离。
   >
   > 最常用的BeanFactory 实现是XmlBeanFactory 类。

6. 解释AOP模块

   > AOP模块用于Spring应用做面向切面的开发， 很多支持由AOP联盟提供，这样就确保了Spring和其他AOP框架的共通性。这个模块将元数据编程引入Spring.

7. 解释JDBC抽象和DAO模块

   > 通过使用JDBC抽象和DAO模块，保证数据库代码的简洁，并能避免数据库资源错误关闭导致的问题，它在各种不同的数据库的错误信息之上，提供了一个统一的异常访问层。它还利用Spring的AOP 模块给Spring应用中的对象提供事务管理服务。

8. 解释对象/关系映射集成模块

   > Spring通过提供ORM模块，支持我们直接在JDBC之上使用一个对象/关系映射(ORM)工具。

9. 解释web模块

   > Spring的WEB模块是构建在application context 模块基础之上，提供一个适合web应用的上下文。这个模块也包括支持多种面向web的任务，如透明地处理多个文件上传请求和程序级请求参数的绑定到你的业务对象。

10. Spring配置文件

   >  Spring配置文件是个XML 文件，这个文件包含了类信息，描述了如何配置它们，以及如何相互调用

11. 什么是Spring IOC容器？

    > Spring IOC 负责创建对象，管理对象并且管理这些对象的整个生命周期。

12. Application通常的实现是什么？

    > **FileSystemXmlApplicationContext ：**此容器从一个XML文件中加载beans的定义，XML Bean 配置文件的全路径名必须提供给它的构造函数。

    > **ClassPathXmlApplicationContext：**此容器也从一个XML文件中加载beans的定义，这里，你需要正确设置classpath因为这个容器将在classpath里找bean配置。

    > **WebXmlApplicationContext：**此容器加载一个XML文件，此文件定义了一个WEB应用的所有bean。

13.  Bean工厂和Application contexts有什么区别？

    > Application contexts提供一种方法处理文本消息，一个通常的做法是加载文件资源（比如镜像），它们可以向注册为监听器的bean发布事件。另外，在容器或容器内的对象上执行的那些不得不由bean工厂以程序化方式处理的操作，可以在Application contexts中以声明的方式处理。Application contexts实现了MessageSource接口，该接口的实现以可插拔的方式提供获取本地化消息的方法。

## 二、依赖注入

1. 什么是Spring依赖注入？

   > 依赖注入也就是IOC。用户不用创建对象，而只需描述它如何被创建。你不在代码里直接描述它如何被创建的。不用在代码中直接组装你的组件和服务，但是要在配置文件中描述哪些组件需要哪些服务，之后一个容器(IOC)把他们组装起来。

2. 有哪些不同的IOC(依赖注入)方式？

   > 构造器依赖注入：构造器依赖注入通过容器触发一个类的构造器来实现的，该类有一系列参数，每个参数代表一个对其他类的依赖。

   > Setter方法注入：Setter方法注入是容器通过调用无参构造器或无参static工厂方法实例化Bean之后，调用Bean的setter方法，即实现了基于setter的参数注入。

3. 哪种依赖注入方式比较建议？

   > 两种依赖注入方式都可以使用，构造器注入和Setter注入。最好的方案是用构造器参数实现强制依赖，setter方法实现可选依赖。

## 三、Spring Beans

> Spring beans是那些形成Spring应用的主干的java对象。他们被Spring IOC容器初始化，装配，和管理。这些beans通过容器中配置的元数据创建。比如，以XML文件中<bean/>的形式被定义。

1. 什么是Spring Beans？

   > 一个Spring Bean的定义包含容器所必知的所有配置元数据，包括如何创建一个bean，它的生命周期以及对应的依赖。

2. 如何给Spring容器配置元数据？

   > 有三种方式给Spring的容器配置对应的元数据。XML配置文件、基于注解的配置、基于java的配置。

3. 你怎样定义类的作用域？

   > 当定义一个<bean/>在Spring中，我们还能给这个bean声明一个作用域。它可以通过Bean定义的scope属性来定义。如当Spring要在需要的时候每次产生一个新的bean实例，bean的scope属性被定位prototype。另一方面，一个bean每次使用的时候必须返回同一个实例，这个bean的scope属性必须设为singleton。

4. 解释Spring支持哪几种bean作用域？

   > singleton:  bean在每个Spring IOC容器中只有一个实例。
   >
   > prototype：一个bean的定义可以有多个实例。
   >
   > request：每次http请求都会创建一个bean，该作用域仅在基于web的Spring ApplicationContext的情况下有效。
   >
   > session：在一个http Session中，一个bean定义对应一个实例。该作用域仅在基于web的Spring ApplicationContext中
   >
   > global-session：在一个全局的Http Session中，一个bean定义对应一个实例。该作用域仅在基于web ApplicationContext情况下有效

   > 缺省的Spring bean的作用域是singleton。

5. Spring框架中的单例bean是线程安全的吗？

   > 不是线程安全的

6. Spring框架中Bean的生命周期？

   1. Spring容器从XMl中读取Bean的定义，并实例化Bean
   2. Spring根据bean的定义填充所有的属性
   3. 如果bean实现了BeanNameAware接口，Spring传递bean的ID到setBeanName方法。
   4. 如果实现了BeanFactoryAware接口，Spring传递beanFactory给setBeanFactory方法。
   5. 如果有任何与bean相关联的BeanPostProcessor，Spring会在postProcesserBeforeInitialization()方法内调用它们。
   6. 如果bean实现IntializingBean了，调用它的afterPropertySet方法，如果bean声明了初始化方法，调用此初始化方法。
   7. 如果有BeanPostProcessors 和bean 关联，这些bean的postProcessAfterInitialization() 方法将被调用。
   8. 如果bean实现了 DisposableBean，它将调用destroy()方法。

7. 哪些是重要的bean的生命周期的

   > 有两个重要的bean生命周期方法，一个是**setup**，它是在容器加载bean的时候被调用，一个是**teardown**,它在容器被卸载的时候被调用。

   > bean标签有两个重要的属性(init-method和destory-method)。他们可以定制初始化和注销方法。

8. 什么是Spring的内部bean？

   > 当一个bean仅被作用于另一个bean的属性的时候，它被声明为一个内部inner bean，在Spring的基于XML的配置元数据中，可以在<property/>或 <constructor-arg/> 元素内使用<bean/> 元素，内部bean通常是匿名的，它们的Scope一般是prototype。

9. 在Spring中如何注入一个java集合？

   > Spring提供一下一种集合配置元素：
   >
   > * <list>类型用于注入一列值，允许有相同的值。
   > * <set> 类型用于注入一组值，不允许有相同的值。
   > * <map> 类型用于注入一组键值对，键和值都可以为任意类型。
   > * <props>类型用于注入一组键值对，键和值都只能为String类型。

10. 什么是bean装配？

    > 装配，或bean 装配是指在Spring 容器中把bean组装到一起，前提是容器需要知道bean的依赖关系，如通过依赖注入来把它们装配到一起。

11. 什么是bean自动装配？

    > Spring 容器能够自动装配相互合作的bean，这意味着容器不需要<constructor-arg>和<property>配置，能通过Bean工厂自动处理bean之间的协作。

12. 解释不同的自动装配方式？

    > - **no**：默认的方式是不进行自动装配，通过显式设置ref 属性来进行装配。
    > - **byName：**通过参数名 自动装配，Spring容器在配置文件中发现bean的autowire属性被设置成byname，之后容器试图匹配、装配和该bean的属性具有相同名字的bean。
    > - **byType:**通过参数类型自动装配，Spring容器在配置文件中发现bean的autowire属性被设置成byType，之后容器试图匹配、装配和该bean的属性具有相同类型的bean。如果有多个bean符合条件，则抛出错误。
    > - **constructor：**这个方式类似于byType， 但是要提供给构造器参数，如果没有确定的带参数的构造器参数类型，将会抛出异常。
    > - **autodetect：**首先尝试使用constructor来自动装配，如果无法工作，则使用byType方式。

13. 你可以在Spring中注入null和而一个空字符串吗？

## 四、Spring注解

1.  什么事基于注解的容器配置？

   > 相对于XML文件，注解型的配置依赖于通过字节码元数据装配组件，而非尖括号的声明。
   >
   > 开发者只需在相应的类或者方法上使用注解的方式，直接组件类中进行配置，而不是使用xml表述bean的装配关系。

2. 怎样开启注解装配？

   > 注解装配在默认情况下是不开启的，为了使用注解，我们必须在配置文件中配置<context:annotation-config/>

3. @Required注解

   > 这个注解表明bean必须在配置的时候设置，通过一个bean定义的现实的属性值或通过自动装配，若@Required注解的bean属性没有被设置，容器将抛出BeanInitializationException。

4. @Autowired注解

   > @Autowired 注解提供了更细粒度的控制，包括在何处以及如何完成自动装配。它的用法和@Required一样，修饰setter方法、构造器、属性或者具有任意名称和/或多个参数的PN方法。

5. @Qualifier注解

   > 当有多个相同类型的bean却只有一个需要自动装配时，将@Qualifier 注解和@Autowire 注解结合使用以消除这种混淆，指定需要装配的确切的bean。

## 五、 Spring数据访问

1. 在Spring框架中如何更有效的使用JDBC？

   > 使用SpringJDBC 框架，资源管理和错误处理的代价都会被减轻。所以开发者只需写statements 和 queries从数据存取数据

2. Spring中支持的事务管理类型？

   > Spring支持两种类型的事务管理：
   >
   > * **编程式事务管理**：这意味你通过编程的方式管理事务，给你带来极大的灵活性，但是难维护。
   > * **声明式事务管理：**这意味着你可以将业务代码和事务管理分离，你只需用注解和XML配置来管理事务。

## 六、Spring面向切面编程

1. 解释AOP

   > 面向切面的编程，或AOP， 是一种编程技术，允许程序模块化横向切割关注点，或横切典型的责任划分，如日志和事务管理。

2. Aspect切面

   > AOP核心就是切面，它将多个类的通用行为封装成可重用的模块，该模块含有一组API提供横切功能。比如，一个日志模块可以被称作日志的AOP切面。根据需求的不同，一个应用程序可以有若干切面。在Spring AOP中，切面通过带有@Aspect注解的类实现。

3. 通知

   > 通知是个在方法执行前或执行后要做的动作，实际上是程序执行时要通过SpringAOP框架触发的代码段。Spring切面可以应用五种类型的通知：
   >
   > 1. **before**：前置通知，在一个方法执行前被调用。
   > 2. **after: **在方法执行之后调用的通知，无论方法执行是否成功。
   > 3. **after-returning: **仅当方法成功完成后执行的通知。
   > 4. **after-throwing: **在方法抛出异常退出时执行的通知。
   > 5. **around: **在方法执行之前和之后调用的通知。

4. 切点

   > 切入点是一个或一组连接点，通知将在这些位置执行。可以通过表达式或匹配的方式指明切入点。

5. 什么是引入？

   > 引入允许我们在已存在的类中增加新的方法和属性。

## 七、Spring的MVC

1. 什么是Spring的MVC框架？

   > Spring 配备构建Web 应用的全功能MVC框架。Spring可以很便捷地和其他MVC框架集成，如Struts，Spring 的MVC框架用控制反转把业务对象和控制逻辑清晰地隔离。它也允许以声明的方式把请求参数和业务对象绑定。

2. DispatcherServlet

   > Spring的MVC框架是围绕DispatcherServlet来设计的，它用来处理所有的HTTP请求和响应。

3. WebApplicationContext

   > WebApplicationContext继承了ApplicationContext并增加了一些Web应用必备的特有的功能，它不同于一般的ApplocationContext，因为它能处理主题，并找到被关联的Servlet。

4. 什么是Spring MVC框架的控制器？

   > 控制器提供一个访问应用程序的行为，此行为通常通过服务接口实现。控制器解析用户输入并将其转换为一个由视图呈现给用户的模型。Spring用一个非常抽象的方式实现了一个控制层，允许用户创建多种用途的控制器。

   ​