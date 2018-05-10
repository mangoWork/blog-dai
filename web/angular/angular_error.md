## 1. 什么是#var？

* 使用#开头，后面跟着name，password等字符串的叫做模板引用变量

* 模板引用变量通常用来引用模板中的某个DOM元素，还可以引用Angular组件或指令。

* 使用＃号来声明引用变量。#phone的意思是声明一个名叫phone的变量来引用<input>元素。代码如下面所示：

  ```html
  <input #phone placeholder="phone number">
  ```

### 1.1 模板引用变量怎么得到它的值？

* 代码如下面所示：

  ```html
  <form (ngSubmit)="onSubmit(heroForm)" #heroForm="ngForm">
    <div class="form-group">
      <label for="name">Name
        <input class="form-control" name="name" required [(ngModel)]="hero.name">
      </label>
    </div>
    <button type="submit" [disabled]="!heroForm.form.valid">Submit</button>
  </form>
  <div [hidden]="!heroForm.form.valid">
    {{submitMessage}}
  </div>
  ```

* 在上述的代码中`heroForm`出现了三次，`heroForm` 的值到是什么？

  * 使用``heroForm`` 必须要先导入`FormsModule`,Angular就不会空值整个表单，那么它就是一个`HTMLFORMElement`实例。这里的`heroForm`实际上就是一个`Angular NgForm`指令的引用，因此具备了跟踪表单的每个控件的值和有效性的能力。
  * 原声的`<form>`元素没有`form`属性，但`NgForm`指令有。

* Tips：

  * 模板引用变量(`#phone`)和`*ngFor`部分看到的模板输入变量(`let phone`)是不同的。

## 2. []的作用、{{var}} 的作用和数据绑定

* `[]`与`()`表示目标绑定

  * 目标是DOM中的某些东西。这个目标可能是（元素|组件|指令）property`[]`、（元素|组件|指令的）事件`()`，或极少数情况下的attribute名。 

    ```html
    <img [src]="heroImageUrl">
    <hero-detail [hero]="currentHero"></hero-detail>
    <div [ngClass]="{'special': isSpecial}"></div>
    ```

    ```html
    <button (click)="onSave()">Save</button>
    <hero-detail (deleteRequest)="deleteHero()"></hero-detail>
    <div (myClick)="clicked=$event" clickable>click me</div>
    ```

* 数据绑定

  * 数据的绑定如下所示：

    | 数据方向            | 语法                                       | 绑定类型                           |
    | --------------- | ---------------------------------------- | ------------------------------ |
    | 单向   从数据源到目标视图  | {{expression}}   [target] = "expression"  bind-target = "expression" | 插值表达式 Property  Attribure  类样式 |
    | 单向    从视图目标到数据源 | (target) = "statement"  on-target = "statement" | 事件                             |
    | 双向              | [(target)] = "expression"  bindon-target = "expression" | 双向                             |

