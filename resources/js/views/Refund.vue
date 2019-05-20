<template>
    <div  class="app header-fixed sidebar-fixed aside-menu-fixed sidebar-lg-show">
        <refund-nav></refund-nav>
        <div class="app-body" id="app">
            <refund-menu></refund-menu>

            <main class="main">
                <refund-breadcrumb></refund-breadcrumb>
                <div class="container-fluid">
                    <div class="animated fadeIn">
                    <!--  @yield('content') -->
                        <router-view></router-view>
                    </div>
                </div>
            </main>
            <refund-side></refund-side>
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

