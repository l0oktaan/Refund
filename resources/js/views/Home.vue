<template>
<div>
    <p>OK</p>
    <router-view @authenticated="setAuthenticated" />
</div>
    
</template>
<script>
export default {
    data() {
            return {
                authenticated: false,
                mockAccount: {
                    username: "nraboy",
                    password: "password"
                }
            }
        },
        mounted() {
            if(!this.authenticated) {
                this.$router.push('/login');
            }
        },
        methods: {
            setAuthenticated(status) {
                this.authenticated = status;
            },
            logout() {
                this.authenticated = false;
            }
        }
}
</script>

<style scoped>

</style>
