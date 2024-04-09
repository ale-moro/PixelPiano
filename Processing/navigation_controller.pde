class NavigationController {

    public NavigationController(){
    }

    public void changePage(Page old_page, Page new_page){
        println("changing page", old_page, " => ", new_page);
        old_page.setVisibility(false);
        activePage = new_page;
        background(255);
        new_page.setVisibility(true);
        new_page.setup();
    }
}