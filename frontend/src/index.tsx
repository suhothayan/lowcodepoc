import * as React from 'react';
import * as ReactDOM from "react-dom";
import {LowCodePortal} from './views/Portal/Portal'
import {MuiThemeProvider} from '@material-ui/core/styles'
import {theme} from './styles'

ReactDOM.render(
    <MuiThemeProvider theme={theme}>
        <LowCodePortal/>
    </MuiThemeProvider>
    ,
    document.getElementById('content')
);


