## 1. 模块

* Angular应用是模块化的，并且Angular有自己的模块系统，它被称为Anggular模块或NgModules。

* 每个Angular应用至少有一个模块（根模块），习惯上命名为AppModule。

* 每一个模块都是一个内聚的代码专注于某一个应用领域、工作流或紧密相关的功能。

* Angular模块（无论是根模块还是特性模块）都是一个带有@NgModule装饰器的类。

* NgModul是一个装饰器函数，它接收一个用来描述模块属性的元数据对象。其中最重要的属性是：

  * declarattions -- 声明本模块中拥有的视图类。Angular有三种视图类：组件、指令和管道。

  * exports -- declarations的子集，可用于其他模块的组件模块。

  * imports -- 本模块声明的组件模块需要的类所在的其他模块。

  * providers --  服务的创建者，并加入全局服务列表中，可用于应用的任何部分。

  * bootstrap -- 指定应用的主视图（根组件），它是所有其他视图的宿主。只有根模块才能配置bootstrap属性。

  * 代码示列（src/app/app.module.ts）：

    ```javascript
    import { NgModule }      from '@angular/core';
    import { BrowserModule } from '@angular/platform-browser';
    @NgModule({
      imports:      [ BrowserModule ],
      providers:    [ Logger ],
      declarations: [ AppComponent ],
      exports:      [ AppComponent ],
      bootstrap:    [ AppComponent ]
    })
    export class AppModule { }
    ```

  * 我们可以通过引导模块来启动应用。在开发期间，通常在一个main.ts文件中引导AppModule，如下所示（src/main.ts）：

    ```javascript
    import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
    import { AppModule } from './app/app.module';

    platformBrowserDynamic().bootstrapModule(AppModule);
    ```

* NgModules 和JavaScript模块比较

  * NgModule是Angular的基础特征之一。

  * JavaScript也有自己的模块系统，用来管理一组JavaScript对象，与Angular的模块系统完全不同且完全无关。

  * 在JavaScript中，每一个文件都是一个模块，文件中定义的所有的对象都从属那个模块。通过export关键字，模块可以把它的某些对象声明为公共的。其它JavaScript模块可以使用import语句来访问这些公共对象。

    ```javascript
    import { NgModule }     from '@angular/core';
    import { AppComponent } from './app.component';
    ```

    ```javascript
    export class AppModule { }
    ```

## 2. Angular模块库

* Angular提供了一组JavaScript模块。可以把他们看作库模块。每个Angular库的名字都带有@angular前缀。

  * 在下列代码中从@angular/core库中导入Component装饰器：

    ```javascript
    import { Component } from '@angular/core';
    ```

## 3. 组件

* 组件负责控制屏幕上的一块区域，我们称之为视图。

* 我们在类中定义组件的应用逻辑，为试图提供支持。组件通过一些属性和方法组成的API与视图交互。

  * 如下面代码所示（src/app/hero-list.component.ts）：

    ```javascript
    export class HeroListComponent implements OnInit {
      heroes: Hero[];
      selectedHero: Hero;

      constructor(private service: HeroService) { }

      ngOnInit() {
        this.heroes = this.service.getHeroes();
      }

      selectHero(hero: Hero) { this.selectedHero = hero; }
    }
    ```

## 4. 模板

* 我们通过组件的自带的模板来定义组件视图。模板以HTML形式存在，告诉Angular如何渲染组件。

  * 如下面代码所示（src/app/hero-list.component.html）：

    ```javascript
    <h2>Hero List</h2>

    <p><i>Pick a hero from the list</i></p>
    <ul>
      <li *ngFor="let hero of heroes" (click)="selectHero(hero)">
        {{hero.name}}
      </li>
    </ul>

    <hero-detail *ngIf="selectedHero" [hero]="selectedHero"></hero-detail>
    ```

## 5. 元数据

* 元数据告诉Angular如何处理一个类。

* 在下列的代码中(src/app/hello-list.component.ts    元数据)：

  ```javascript
  @Component({
    selector:    'hero-list',
    templateUrl: './hero-list.component.html',
    providers:  [ HeroService ]
  })
  export class HeroListComponent implements OnInit {
  /* . . . */
  }
  ```

* 在上述代码中，我们通过装饰器来附加元数据，在这里的装饰器把紧随其后的类标记成了组件。

* @Component 装饰器的配置项包括：

  * selector ： CSS选择器，它告诉Angular在父级HTML中查找 “<hero-list></hero-list>”标签，创建并且插入该组件。
  * templateUrl ： 组件HTML模版对应的地址。
  * providers ： 组件所需服务的依赖注入提供商数组。这是在告诉Angular： 该组件的构造函数需要一个HeroService服务，这样组件就可以从中获取数据。

*  @Component里面的元数据会告诉Angular从哪里获取你为组件指定的主要的构建块。模版、元数据和组件共同描绘出这个视图。

* 其他的元数据装饰器用类似的方式指导Angular的行为。例如：@Injectable、@Input和@output等是一些常用的装饰器。

## 6. 数据绑定

* Angular支持数据绑定，一种让模板的各个部分与组件的各部分相互合作的机制。我们往模板HTML中添加绑定标记，来告诉Angular如何把二者进行绑定。绑定方式有：绑定到DOM、绑定自DOM以及双向绑定。代码如下所示：

  ```html
  <li>{{hero.name}}</li> <!-- 显示主键的hero.name属性的值 -->
  <hero-detail [hero]="selectedHero"></hero-detail>  <!-- 属性绑定，把父组件的值HeroListComponent的selectedHero的值传递到子组件中-->
  <li (click)="selectHero(hero)"></li>   <!-- 绑定事件，调用相应方法 -->
  <input [(ngModel)]="hero.name">   <!-- 双向数据绑定 -->
  ```

## 7. 指令

* Angular模板是动态的。当Angular渲染他们的时，它会根据指令提供的操作对DOM进行转换。

* 组件是一个带模板的指令；@Component装饰器实际上就是一个@Directive装饰器。只是扩展了一些面向模板的特性。

* 其他类型的指令：

  * 结构型指令：通过在DOM中添加、移除和替换元素来修改布局。如下代码所示：

    ```HTML
    <li *ngFor="let hero of heroes"></li>
    <hero-detail *ngIf="selectedHero"></hero-detail>
    ```

  * 属性型指令 :   修改一个现有元素的外观或行为。在模板中，他们看起来就像是标准的HTML属性。如下代码所示：

    ```html
    <input [(ngModel)]="hero.name">
    ```

## 8. 服务

* 几乎任何东西都可以是一个服务，典型的服务就是一个类，具有专注地、明确的用途。它应该做一件特定的事情，并把它做好。

  * 如下面代码所示：

    ```javascript
    export class HeroService {
      private heroes: Hero[] = [];

      constructor(
        private backend: BackendService,
        private logger: Logger) { }

      getHeroes() {
        this.backend.getAll(Hero).then( (heroes: Hero[]) => {
          this.logger.log(`Fetched ${heroes.length} heroes.`);
          this.heroes.push(...heroes); // fill cache
        });
        return this.heroes;
      }
    }
    ```

## 9. 依赖注入

* 依赖注入是提供类的新实例的一种方式，还负责处理好类所需的全部依赖。大多数依赖都是服务。Angular使用依赖注入来提供新组件以及组件所需的服务。

* Angular通过查看构造函数的参数得知组件需要哪些服务。例如HerListComponent组件需要一盒HeroService服务：

  ```javascript
  constructor(private service: HeroService) { }
  ```

* 当Abgular创建组件的时候，会首先为组件所需的服务请求一个注入器，注入器维护了一个服务的实例，并且添加到容器中，然后把这个服务返回给Angular。当所有的请求的服务都被解析完并且返回时，Angular会以这些服务为参数去调用组件的构造函数。这就是依赖注入。

* 如果注入器还没有HeroService，它怎么知道如何创建一个呢？

  * 我们必须先用注入器为HeroService注册一个提供商。提供上用来创建或返回服务。通常就是这个服务类本身（相当于new HeroService（））。

  * 如下面代码所示：

    ```javascript
    providers: [
      BackendService,
      HeroService,
      Logger
    ],
      
      
      @Component({
      selector:    'hero-list',
      templateUrl: './hero-list.component.html',
      providers:  [ HeroService ]
    })
    ```