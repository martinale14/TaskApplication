import React, { Component } from 'react';

class App extends Component {

    url = '192.168.20.27';

    constructor(props) {
        super(props);
        this.state = {
            title: '',
            description: '',
            _id: '',
            tasks: [],
        }
        this.addTask = this.addTask.bind(this);
        this.handleChange = this.handleChange.bind(this);
    }

    componentDidMount() {
        this.fetchData();
        this.socket = new WebSocket(`ws://${this.url}:3000`);
        this.socket.addEventListener('open', function (event) {
            console.log('Connected to WS Server')
        });
        this.socket.onmessage = (msg) => {
            if (msg.data == 'makeChange') {
                this.fetchData();
            }
        };
    }

    fetchData() {
        fetch('/api/tasks')
            .then(res => res.json())
            .then(data => {
                this.setState({ tasks: data });
                console.log(this.state.tasks);
            });
    }

    addTask(e) {
        e.preventDefault();
        if (this.state._id) {
            fetch(`/api/tasks/${this.state._id}`, {
                method: 'PUT',
                body: JSON.stringify({
                    title: this.state.title,
                    description: this.state.description
                }),
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            })
                .then(res => res.json())
                .then(data => {
                    console.log(data);
                    window.M.toast({ html: 'Task Updated' });
                    this.setState({ title: '', description: '', _id: '' });
                    this.fetchData();
                })
                .catch(err => console.error(err));
        } else {
            fetch('/api/tasks', {
                method: 'POST',
                body: JSON.stringify({ title: this.state.title, description: this.state.description }),
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            })
                .then(res => res.json())
                .then(data => {
                    console.log(data);
                    window.M.toast({ html: 'Task Saved' });
                    this.setState({ title: '', description: '' });
                    this.fetchData();
                })
                .catch(err => console.error(err));

        }
        this.socket.send('true');

    }

    handleChange(e) {
        const { name, value } = e.target;
        this.setState({
            [name]: value
        });
    }

    editTask(id) {

        fetch(`/api/tasks/${id}`)
            .then(res => res.json())
            .then(data => {
                console.log(data);
                this.setState({
                    title: data.title,
                    description: data.description,
                    _id: data._id
                });
            });

    }

    deleteTask(id) {

        fetch(`/api/tasks/${id}`, {
            method: 'DELETE',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
            .then(res => res.json())
            .then(data => {
                console.log(data);
                M.toast({ html: 'Task Deleted' });
                this.fetchData();
            });

        this.socket.send('true');
    }

    render() {

        return (
            <div>

                <nav className="light-blue darken-4">
                    <div className="container">
                        <div className="nav-wrapper">
                            <a href="#" className="brand-logo">MERN STACK</a>
                        </div>
                    </div>
                </nav>

                <div className="container">
                    <div className="row">

                        <div className="col s5">
                            <div className="card">
                                <div className="card-content">

                                    <form onSubmit={this.addTask}>
                                        <div className="row">
                                            <div className="input-field col s12">
                                                <input name="title" value={this.state.title} onChange={this.handleChange} type="text" placeholder="Task Title" autoFocus />
                                            </div>
                                        </div>
                                        <div className="row">
                                            <div className="input-field col s12">
                                                <textarea name="description" value={this.state.description} onChange={this.handleChange} cols="30" rows="10" placeholder="Task Description" className="materialize-textarea" autoFocus />
                                            </div>
                                        </div>

                                        <button type="submit" className="btn light-blue darken-4">SEND</button>

                                    </form>

                                </div>
                            </div>
                        </div>

                        <div className="col s7">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {
                                        this.state.tasks.map(task => {

                                            return (
                                                <tr key={task._id}>
                                                    <td>{task.title}</td>
                                                    <td>{task.description}</td>
                                                    <td>
                                                        <button onClick={() => this.deleteTask(task._id)} className="btn light-blue darken-4">
                                                            <i className="material-icons">delete</i>
                                                        </button>
                                                        <button onClick={() => this.editTask(task._id)} className="btn light-blue darken-4" style={{ margin: '4px' }}>
                                                            <i className="material-icons">edit</i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            );

                                        })
                                    }
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
        );

    };

}

export default App;