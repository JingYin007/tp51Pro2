
function Url(props) {
    return <h3>网站地址：{props.url}</h3>;
}
function Nickname(props) {
    return <h4 style={myStyle}>网站小名：{props.nickname}</h4>;
}

/**
 * ES6 定义 class组件
 */
class Clock extends React.Component{
    constructor(props) {
        super(props);
        this.state = {date: new Date()};
        // 这边绑定是必要的，这样 `this` 才能在回调函数中使用
        this.handleClick = this.handleClick.bind(this);
    }

    /**
     * 进入真实 DOM 后
     */
    componentDidMount(){
        this.timer = setInterval(()=>this.refresh(), 1000)
    }

    /**
     * 将要退出真实 DOM 时
     */
    componentWillUnmount() {
        clearInterval(this.timer);
    }
    static propTypes = {
        word: PropTypes.string.isRequired
    }
    static defaultProps = {title : "Hello World" };

    handleClick(e) {
        e.preventDefault();
        console.log('The link was clicked.');
        this.refs.myTextInput.focus();
    }

    render(){
        return(
            <div>
                <h1>{this.props.className}</h1>
                <h1>Hello, {this.props.word}</h1>
                <h2>现在是 {this.state.date.toLocaleTimeString()}.</h2>
                <Nickname nickname={'moTzxx'} />
                <Url url={'xxx.com/moxxx/ss/tm'} />
                <h5>一个默认设定的值：{this.props.title}</h5>

                <button onClick={this.handleClick}>又一个按钮！</button>
                <input type="text" ref="myTextInput" />
            </div>
        );
    }

    refresh(){
        this.setState({
            date:new Date()
        })
    }
}

// 第二种 类方法的验证设置
// Clock.propTypes = {
//     word: PropTypes.string.isRequired
// };


let myStyle = {
    fontSize:18,
    color: '#33ee55'
}


function reactClick(){
    let elementx = <h1>你大爷的！</h1>;
    ReactDOM.render(
        elementx, document.getElementById('example2')
    );
}

const element = (
    <div>
        <h1 style={myStyle}>这是咋哩!</h1>
        <button className="layui-btn layui-btn-sm layui-btn-danger"  onClick={reactClick}>react</button>
    </div>)

ReactDOM.render(
    element,
    document.getElementById('example')
);

/*-- 理解为在此实例化 Clock 组件 --*/
let element2 = ( <Clock className={'Hoo急急急'}  word={'1'} /> );
ReactDOM.render(
    element2, document.getElementById('example2')
);


