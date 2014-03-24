Visualforce.remoting.Manager.invokeAction(
"{!$RemoteAction.ThreeVotApiController.handleRest}", "post", "Account", '{"Name":"Rodco2"}',
function(result, event){
  console.log(result);
}, 
{escape: true}
);

ThreeVotApiController.handleRest("post", "Account", '{"Name":"Rodco2"}', function(result, event){
  console.log(result);
},{escape: true}