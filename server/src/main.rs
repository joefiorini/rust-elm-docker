#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate rocket_cors;

use rocket::http::Method;
use rocket_cors::{AllowedHeaders, AllowedOrigins};

#[get("/hello/<name>")]
fn hello_name(name: String) -> String {
    format!("Hello {}!", name)
}

fn main() {
    let (allowed_origins, failed_origins) = AllowedOrigins::some(&["http://localhost:8000"]);
    assert!(failed_origins.is_empty());

    let options = rocket_cors::Cors {
        allowed_origins: allowed_origins,
        allowed_methods: vec![Method::Get].into_iter().map(From::from).collect(),
        allowed_headers: AllowedHeaders::some(&["Authorization", "Accept"]),
        allow_credentials: true,
        ..Default::default()
    };

    rocket::ignite()
        .mount("/", routes![hello_name])
        .attach(options)
        .launch();
}
