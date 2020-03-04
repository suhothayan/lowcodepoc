import * as React from 'react';
import {NavBar} from '../NavBar'
import { EditorWrapper } from '../EditorWrapper';
import { ConfigDrawer } from '../ConfigDrawer';
import { createStyles, makeStyles, Theme } from '@material-ui/core/styles';
import { Loader } from '../Loader';
import { retrieveAccessToken } from '../../utils/token-utils';
import { CONFIG } from '../../config';

const useStyles = makeStyles((theme: Theme)=> createStyles({
    body: {
        height:'100%'
    }
}))

export function LowCodePortal(){

    const classes = useStyles();

    const [apiToken,setApiToken] = React.useState(null);
    const [state,setState] = React.useState({
        drawerVisible:false
    })

    function handleVisibility(value:boolean){
        setState({
            drawerVisible:value
        })
    }

    async function callTokenRetrieve(){

        const res = await retrieveAccessToken(CONFIG.API_KEY);
        setApiToken(res.data._token);
    }

    React.useEffect(()=>{
        console.log("effect")
       callTokenRetrieve();
    },[])
    
    return(
        <React.Fragment>
            <NavBar/>
            {apiToken  === null &&  <Loader/>}
            <div className={classes.body}>
                 {apiToken  !== null &&  <EditorWrapper openConfig={handleVisibility} apiToken={apiToken}></EditorWrapper>}
                <ConfigDrawer drawerVisible={state.drawerVisible} handleVisibility={handleVisibility}/>
            </div>
            
        </React.Fragment>
    )
}
