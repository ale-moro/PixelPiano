class NavigationController {

    public NavigationController(){

    }

    public void changePage(Page old_page, Page new_page){
        old_page.setVisibility(false);
        new_page.setVisibility(true);
        activePage = new_page;
    }
}