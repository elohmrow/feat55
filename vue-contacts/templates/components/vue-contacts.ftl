<div id="vueApp">
    <h3>
      Contacts list
    </h3>
         
    <ul>
      <li v-for="user in contacts">
        {{ user.firstName }} {{ user.lastName }} <button v-on:click="deleteContact(user.name)">Delete</button>
[#if cmsfn.editMode]
  <li>
    <input v-model="newFirstName" placeholder="new contact first name">
    <input v-model="newLastName" placeholder="last name">
    <button v-on:click="addContact()">Add</button>
  </li>
[/#if]
      </li>
    </ul> 
</div>
 
<script type="text/javascript">
  new Vue({
    el: '#vueApp',
data: {
  contacts: [],
  newFirstName: '',
  newLastName: ''
},
    mounted: function() {
      this.contacts = this.loadContacts();
    },
    methods: {
      loadContacts: function() {
        this.$http.get('http://localhost:8080/magnoliaAuthor/.rest/nodes/v1/contacts/?depth=4&excludeNodeTypes=rep%3Asystem%2Crep%3AAccessControl&includeMetadata=false').then(response => {
          var contacts = response.body.node;

        contacts.forEach( function(item, index, arr) {
            item.property.forEach( function(item){
                if(item.name == "firstName") {
                    arr[index].firstName = item.value[0];
                }
                if(item.name == "lastName") {
                    arr[index].lastName = item.value[0];
                }
            }); 
        });

          this.contacts = contacts;
        });
      },
        [#if cmsfn.editMode]
                addContact: function() {
                  if( (this.newFirstName != '') || (this.newLastName != '')) {
                    var name = this.newFirstName+this.newLastName;
                    var path = "/"+name;
                    this.$http.put('http://localhost:8080/magnoliaAuthor/.rest/nodes/v1/contacts/', {"name": name,"path": path,"type": "mgnl:contact","property": [{"name": "firstName","type": "String","multiple": false,"value": [this.newFirstName]},{"name": "lastName","type": "String","multiple": false,"value": [this.newLastName]}]}).then(response => {
                      if(response.status == 200) {
                        this.loadContacts();
                        this.newFirstName = '';
                        this.newLastName = '';
                      }
                    });
                  }
                }
              [/#if],
        [#if cmsfn.editMode]
                deleteContact: function(name) {
                    this.$http.delete('http://localhost:8080/magnoliaAuthor/.rest/nodes/v1/contacts/' + name).then(response => {
                      if(response.status == 200) {
                        this.loadContacts();
        }
                    
        });
                }
      [/#if],
    }
  });
</script>
