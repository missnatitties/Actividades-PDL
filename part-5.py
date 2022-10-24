import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import plotly.express as px

import pandas as pd

df = pd.read_csv('C:/Users/ncordova/Downloads/auto-mpg.csv')

df["mpg"] = df["mpg"].astype(int)
a=df.iloc[:,8]
df['name'] = a.str.split(' ').str[0]

app = dash.Dash(__name__)

app.layout = html.Div(children=[
    html.H1(children='Violin_graph', style={'color':'black'}),
    dcc.Graph(id="graph_mpg"),
    dcc.Dropdown(
        id='car_name_dropdown',
        options=[
            {'label': 'ford', 'value': 'ford'},
            {'label': 'chevrolet', 'value': 'chevrolet'},
            {'label': 'toyota', 'value': 'toyota'}
        ],
        value= 'ford'
        ),
])

@app.callback(
    Output('graph_mpg', 'figure'),
    Input('car_name_dropdown', 'value')
)
def update_figure(selected_car):
    filtered_df = df[df.name == selected_car]
    
    fig= px.violin(filtered_df, y="mpg", x="name", color="name", box=True, points="all", hover_data=df.columns)
    
    fig.update_layout(transition_duration=500)
    
    return fig

if __name__ == '__main__':
    app.run_server(debug=True, use_reloader=False)