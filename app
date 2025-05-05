from flask import Flask, render_template, redirect, request
import spotipy
import time
from spotipy.oauth2 import SpotifyOAuth

app = Flask(__name__)

sp_oauth = SpotifyOAuth(
    client_id="202f8f4519a6416d87afa8d44dd73af3",
    client_secret="7edcb15ed95e4be1a2478092951b8a2b",
    redirect_uri="http://127.0.0.1:5000",
    scope="user-top-read"
)

@app.route("/")
def login():
    auth_url = sp_oauth.get_authorize_url()
    time.sleep(1)
    return redirect(auth_url)

@app.route("/callback")
def callback():
    code = request.args.get('code')
    token_info = sp_oauth.get_access_token(code)
    sp = spotipy.Spotify(auth=token_info['access_token'])

    top_tracks = sp.current_user_top_tracks(limit=10, time_range='long_term')['items']
    tracks = [{"name": t["name"], "artist": t["artists"][0]["name"]} for t in top_tracks]

    return render_template("wrapped.html", tracks=tracks)

if __name__ == "__main__":
    app.run(debug=True, port=5000)
