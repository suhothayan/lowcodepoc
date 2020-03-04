import axios from 'axios'

export async function retrieveAccessToken(apiKey : string){
    return axios.post("https://api.creately.com/api/service/auth", {"auth":apiKey},{headers:{
        'Content-type':'application/json'
    }})
}
