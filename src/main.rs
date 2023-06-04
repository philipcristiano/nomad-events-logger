#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = nomad_client_rs::Config::from_env();
    let client = nomad_client_rs::NomadClient::new(config);

    let params = nomad_client_rs::api::event::models::EventsSubscribeParams::default();
    let (res, mut handle) = client.events_subscribe(&params);

    while !res.is_finished() {
        let msg = handle.recv().await;
        if msg.is_some() {
            let ser = serde_json::to_string(&msg).expect("Not json");
            println!("{}", ser);
        }
    }

    Ok(())
}
