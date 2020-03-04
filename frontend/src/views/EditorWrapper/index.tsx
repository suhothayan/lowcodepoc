import * as React from 'react'
import { useEffect } from 'react';
import { createStyles, makeStyles, Theme } from '@material-ui/core/styles';

interface EditorWrapperProps {
    openConfig: Function
    apiToken: string
}

function send(msg : {event:string,data:{token:string}} ){
    const str = JSON.stringify(msg);
    const iframeElement = document.getElementById("creately-iframe") as HTMLFrameElement;
    iframeElement.contentWindow.postMessage("str","https://app.creately.com")
}

interface TypeEventListner{
    [key:string]:Function | any
}
const useStyles = makeStyles((theme: Theme)=> createStyles({
    iframe: {
        height:'90vh'
    }
}))
const eventListners:TypeEventListner = {
    'document:load':[],
    'shape:touch':[]
}

export function EditorWrapper (props : EditorWrapperProps){
    const classes = useStyles();

    const openClick = (event: React.MouseEvent<HTMLElement>) => {
        props.openConfig(true);
    }

    useEffect(()=>{
        window.addEventListener("message",handleIframeEvent);
    })



    useEffect(()=>{
        eventListners['document:load'].push( (msg:any) => {
            send ({event:'user:setToken', 
            data:{token: props.apiToken}})
            console.log("DATA SENT" + props.apiToken);
        })

        eventListners['shape:touch'].push((msg:any)=>{
            props.openConfig(true);
        })

        return function cleanup(){
            eventListners['shape:touch']=[];
            eventListners['user:setToken']=[];
        }
    },[]);

    return(
        
        <React.Fragment>            
            <div className={classes.iframe}>
                <iframe id="creately-iframe" scrolling={"yes"} src="https://app.creately.com/diagram/OvoHCkfM6SW/view" frameBorder={"0"} width={"100%"} height={"100%"}></iframe>
            </div>
            <button onClick={openClick}>Click me</button>
        </React.Fragment>
    )
}

function handleIframeEvent(event : MessageEvent){
    try {
        if ( event.origin !== "https://app.creately.com" ) {
            return 
        }
        const obj = JSON.parse( event.data );
        if ( obj.source !== "creately" ) {
            return;
        }

        if ( !obj || typeof obj !== 'object' || obj.source !=='creately' ) {
            return;
        }
        const listeners = eventListners[obj.event];
        if (!listeners) {
            return;
        }
        for ( const fn of listeners ) {
            fn(event.data);
        }
    } catch (err) {
        // TODO: handle the error
        console.log(err);
    }
}
