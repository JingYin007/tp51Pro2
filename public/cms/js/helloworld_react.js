function Url(props) {
    return <h3>网站地址：{props.url}</h3>;
}
function Nickname(props) {
    return <h4 style={myStyle}>网站小名：{props.nickname}</h4>;
}

class Clock extends React.Component{
    constructor(props) {
        super(props);
        this.state = {date: new Date()};
    }
    componentDidMount(){
        this.timer = setInterval(()=>this.refresh(), 1000)
    }
    componentWillUnmount() {
        clearInterval(this.timer);
    }

    render(){
        return(
            <div>
                <h1>{this.props.className}</h1>
                <h1>Hello, {this.props.word}</h1>
                <h2>现在是 {this.state.date.toLocaleTimeString()}.</h2>
                <Nickname nickname={'moTzxx'} />
                <Url url={'xxx.com/moxxx/ss/tm'} />
            </div>
        );
    }

    refresh(){
        this.setState({
            date:new Date()
        })
    }
}
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

const element =
    <div>
        <h1 style={myStyle}>这是咋哩!</h1>
        <button className="layui-btn layui-btn-sm layui-btn-danger"  onClick={reactClick}>react</button>
    </div>

ReactDOM.render(
    element,
    document.getElementById('example')
);

let element2 = <Clock className={'Hoo急急急'}  word={"你大爷!"} />;
ReactDOM.render(
    element2, document.getElementById('example2')
);


