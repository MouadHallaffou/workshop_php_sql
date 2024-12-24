<?php 
include('./config/database.php');


function get_all_articles($mysqli){
    $query = "select * from articles";
    $result = mysqli_query($mysqli,$query);
    if($result){
        return $result->fetch_assoc();
    }
}

function get_category_stats($mysqli){

}

function get_top_users($mysqli){


}

function get_top_articles($mysqli){
    
}

function getTableCount($mysqli, $articles){
    $query = "select count(*) as count from $articles";
    $result = mysqli_query($mysqli,$query);
    if($result){
        $row = mysqli_fetch_assoc($result);
        return $row['count'];
    }
    
}



?>