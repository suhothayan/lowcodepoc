import * as React from 'react';
import Drawer from '@material-ui/core/Drawer';
import TextField from '@material-ui/core/TextField';
import { createStyles, makeStyles, Theme } from '@material-ui/core/styles';


export interface DrawerProps {
    drawerVisible:boolean;
    handleVisibility: Function;
}

const useStyles = makeStyles((theme: Theme)=> createStyles({
    root: {
        '& .MuiTextField-root': {
          margin: theme.spacing(1),
          width: 200,
        }
    }
}))

export function ConfigDrawer(props: DrawerProps){
    const classes = useStyles();
    const setDrawer = () => {
        props.handleVisibility(false);
    }
    
    return (
        <Drawer anchor="right" open={props.drawerVisible} onClose={setDrawer}>
            <form className={classes.root}>
            <TextField
          id="outlined-helperText"
          label="plugin-id"
          variant="outlined"
        />
            </form>
        </Drawer>
    );
}



