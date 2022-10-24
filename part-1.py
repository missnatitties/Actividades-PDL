import dash
from dash import html

app = dash.Dash(__name__)

app.layout = html.Div(children=[
    html.Img(
        src='assets\\sustainability.jpg',
        style={'width': '50%', 'border': '1px solid red'},
        alt='image'),

    html.H1(children='Isaac Hernandez-Cedeño', style={'color': 'blue'}),
    html.P('Data Science Consultant at NEORIS', style={'color': 'green', 'border': '2px solid blue'})
])

if __name__ == '__main__':
    app.run_server(debug=True)