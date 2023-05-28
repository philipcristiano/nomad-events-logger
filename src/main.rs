use serde_json::{Value};
use clap::Parser;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Nomad API
    #[arg(short, long, default_value_t = String::from("http://127.0.0.1:4646/v1/event/stream"))]
    url: String,

}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();

    let url = args.url;
    let mut res = reqwest::get(url).await?;

    // loop until \n encountered, adding chunks to a string or something, then try to parse
    loop {
        let mut chunks = vec!();
        while let Some(chunk) = res.chunk().await? {
            let is_newline = chunk.eq("\n");
            chunks.push(chunk);
            if is_newline {break};
        }
        let v: Value = serde_json::from_slice(chunks.concat().as_slice())?;
        let events = v["Events"].as_array();

        for e in events {
            println!("{:?}", e[0].to_string());
        }
    }

    Ok(())
}
