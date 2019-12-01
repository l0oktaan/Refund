<template>
    <div  class="app header-fixed sidebar-fixed aside-menu-fixed sidebar-lg-show">
        <admin-nav></admin-nav>
        <div class="app-body" id="app">
            <admin-menu></admin-menu>

            <main class="main">
                
                <breadcrumbs/>
                <div class="container-fluid">
                    <div class="animated fadeIn">
                    <!--  @yield('content') -->
                        <router-view></router-view>
                    </div>
                </div>
            </main>
            <admin-side></admin-side>
        </div> <!-- End app-body -->
        <footer class="app-footer">
            <div>
                <a href="https://coreui.io">My App</a>
                <span>&copy; 2018 creativeLabs.</span>
            </div>
            <div class="ml-auto">
                <span>Powered by</span>
                <a href="https://coreui.io">My Company</a>
            </div>
        </footer>
    </div>
</template>
<script>

