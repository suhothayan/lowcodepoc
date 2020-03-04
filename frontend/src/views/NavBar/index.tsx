import * as React from 'react';
import {createStyles,makeStyles,Theme} from '@material-ui/core/styles'
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';

const useStyles = makeStyles((theme :Theme) =>
    createStyles({
        root: {
            flexGrow: 1,
        },
        menuButton: {
            marginRight: theme.spacing(2),
        },
        title: {
            flexGrow: 1,
            cursor: "pointer"
        },
        appBar: {
            backgroundColor: "#ffffff",
            boxShadow: "none",
            borderBottom: "2px solid #E5E5E5",
            color: "#1DBAB4"
        },
        paper: {
            padding: theme.spacing(2),
            textAlign: 'center',
            color: theme.palette.text.secondary,
        }
    })
);



export function NavBar () {
    const classes = useStyles();

    return (
        <div className = {classes.root}>
            <AppBar position="static" className={classes.appBar}>
                <Toolbar>
                    <Typography
                        variant="h6"
                        className={classes.title}
                        data-testid="home-link"
                    >
                        low code poc
                    </Typography>
                </Toolbar>
            </AppBar>
        </div>
    )
}
